import Foundation
import Firebase
import Photos

// MARK: Public UploadService API

final class UploadService {
    static let shared = UploadService()
    
    private var uploadChannel: FlutterMethodChannel!
    
    private init() {}
    
    /**
     Registering uploadFiles method and upload_platform channel.
     */
    func configureFlutterHandler(flutterBinaryMessenger: FlutterBinaryMessenger) {
        uploadChannel = FlutterMethodChannel(name: Constants.channelName, binaryMessenger: flutterBinaryMessenger)
        
        uploadChannel.setMethodCallHandler { [weak self] (flutterCall, flutterResult) in
            let flutterArguments = flutterCall.arguments as? NSDictionary
            
            switch flutterCall.method {
            case Constants.uploadMethod:
                guard let (groupId, channelId, paths, localIdentifiers) = self?.parseUploadFilesData(
                    flutterArguments: flutterArguments) else { return }
                
                DispatchQueue.global().async {
                    self?.uploadFiles(
                        groupId: groupId,
                        channelId: channelId,
                        paths: paths,
                        localIdentifiers: localIdentifiers,
                        flutterResult: flutterResult
                    )
                }
                
            default: flutterResult(FlutterMethodNotImplemented)
            }
        }
    }
}

// MARK: Private UploadService APIs

private extension UploadService {
    
    func messageDocumentReference(
        groupId: String,
        channelId: String,
        messageId: String
    ) -> DocumentReference {
        let db = Firestore.firestore()
        return db.collection(Constants.groupsCollection)
            .document(groupId)
            .collection(Constants.channelsCollection)
            .document(channelId)
            .collection(Constants.messagesCollection)
            .document(messageId)
    }
    
    func handleFailedUpload(
        flutterResult: FlutterResult,
        groupId: String,
        channelId: String,
        messageId: String
    ) {
        addMediaMessageError(
            groupId: groupId,
            channelId: channelId,
            messageId: messageId
        )
        flutterResult(FlutterError())
        updateUI(ongoingBackgroundActivity: false)
    }
    
    func updateUI(ongoingBackgroundActivity: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = ongoingBackgroundActivity
        }
    }
    
    /**
     Uploading an image which has just been taken in the app.
     - Parameter groupId: Unique identifier of group the image should be uploaded to.
     - Parameter channelId: Unique identifier of channel the image should be uploaded to.
     - Parameter paths: Paths of images.
     */
    func uploadPathImages(
        groupId: String,
        channelId: String,
        paths: [String],
        flutterResult: FlutterResult
    ) {
        guard paths.count > 0 else { return }
        updateUI(ongoingBackgroundActivity: true)
        
        guard let messageId = createMediaMessage(
            groupId: groupId,
            channelId: channelId,
            media: paths
            ) else {
                // We're currently ignoring this case
                return
        }
        
        var downloadURLs = [String]()
        
        for path in paths {
            let fileURL = URL(fileURLWithPath: path)
            guard let imageData = ImageProcessingService.processImageToJPEG(for: fileURL) else { continue }
            
            let fileName = fileURL.lastPathComponent
            if let downloadURL = uploadImage(
                groupId: groupId,
                channelId: channelId,
                messageId: messageId,
                data: imageData,
                fileName: fileName)
            {
                downloadURLs.append(downloadURL)
            } else {
                handleFailedUpload(flutterResult: flutterResult, groupId: groupId, channelId: channelId, messageId: messageId)
                return;
            }
        }
        
        addMediaToMessage(groupId: groupId, channelId: channelId, messageId: messageId, urls: downloadURLs)
        updateUI(ongoingBackgroundActivity: false)
    }
    
    /**
     Locally retrieves, processes and uploads images to firebase.
     
     - Parameter groupId: The unique group identifier.
     - Parameter channelId: The unique channel identifier.
     - Parameter paths: Paths for photos taken within the app.
     - Parameter localIdentifiers: Local unique identifiers for image assets stored on the iOS device.
     */
    func uploadFiles(
        groupId: String,
        channelId: String,
        paths: [String],
        localIdentifiers: [String],
        flutterResult: FlutterResult
    ) {
        // Attempt to upload image taken in-app. No message needs to be created.
        if paths.count > 0 {
            uploadPathImages(
                groupId: groupId,
                channelId: channelId,
                paths: paths,
                flutterResult: flutterResult
            )
            return
        }
        
        // Upload selected images
        let assetsFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: localIdentifiers, options: nil)
        
        guard assetsFetchResult.count > 0 else {
            return
        }
        
        updateUI(ongoingBackgroundActivity: true)
        
        // Create new message
        guard let messageId = createMediaMessage(
            groupId: groupId,
            channelId: channelId,
            media: localIdentifiers
            ) else {
                // We're currently ignoring this case
                return
        }
        
        let imageManager = PHImageManager.default()
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isSynchronous = true
        var downloadURLs = [String]()
        
        for i in 0 ..< assetsFetchResult.count {
            let asset = assetsFetchResult[i]
            
            // Load actual image data for selected local assets
            imageManager.requestImageData(
                for: asset,
                options: imageRequestOptions,
                resultHandler: { [weak self] (data, _, _, _) in
                    guard let imageData = data else { return }
                    
                    // Start uploading selected local asset
                    // Replace slashes to avoid creating additional folders in firebase.
                    let fileName = asset.localIdentifier.replacingOccurrences(of: "/", with: "-") + Constants.jpgExtension
                    if let downloadURL = self?.uploadImage(
                        groupId: groupId,
                        channelId: channelId,
                        messageId: messageId,
                        data: imageData,
                        fileName: fileName
                        ) {
                        downloadURLs.append(downloadURL)
                    }
                }
            )
        }
        
        // Check and handle case where not all images have been uploaded
        if downloadURLs.count != localIdentifiers.count {
            handleFailedUpload(
                flutterResult: flutterResult,
                groupId: groupId,
                channelId: channelId,
                messageId: messageId
            )
        } else {
            // Add uploaded asset url to message
            addMediaToMessage(
                groupId: groupId,
                channelId: channelId,
                messageId: messageId,
                urls: downloadURLs
            )
            updateUI(ongoingBackgroundActivity: false)
        }
    }
    
    func parseUploadFilesData(flutterArguments: NSDictionary?) -> (
        groupId: String,
        channelId: String,
        paths: [String],
        localIdentifiers: [String])?
    {
        guard let groupId = flutterArguments?.value(forKey: Constants.keyGroupId) as? String,
            let channelId = flutterArguments?.value(forKey: Constants.keyChannelId) as? String,
            let paths = flutterArguments?.value(forKey: Constants.keyFilePaths) as? [String],
            let localIdentifiers = flutterArguments?.value(forKey: Constants.keyLocalIdentifiers) as? [String]
            else {
                return nil
        }
        
        return (groupId, channelId, paths, localIdentifiers)
    }
    
    func uploadImage(
        groupId: String,
        channelId: String,
        messageId: String,
        data: Data,
        fileName: String
    ) -> String? {
        let storage = Storage.storage()
        var downloadableURL: String? = nil
        
        guard let imageData = ImageProcessingService.processImageToJPEG(for: data) else {
            return nil
        }
        
        // Files are stored inside the same path as the original message is but in Storages
        let storageRef = storage.reference()
        let fileRef = storageRef.child(
            Constants.messagePath(
                groupId: groupId,
                channelId: channelId,
                messageId: messageId)
                + fileName)
        
        // Since we run inside a dispatch queue, we want to wait for the callbacks to finish to continue
        let semaphore = DispatchSemaphore(value: 0)
        _ = fileRef.putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                semaphore.signal()
                return
            }
            
            fileRef.downloadURL { (url, error) in
                guard let downloadURL: URL = url else {
                    semaphore.signal()
                    return
                }
                
                downloadableURL = downloadURL.absoluteString
                semaphore.signal()
            }
        }
        
        // Wait for uploads to finish
        semaphore.wait()
        return downloadableURL
    }
    
    /**
     This method updates the existing media message and adds the uploaded files
     */
    func addMediaToMessage(
        groupId: String,
        channelId: String,
        messageId: String,
        urls: [String]
    ) {
        let semaphore = DispatchSemaphore(value: 0)
        messageDocumentReference(groupId: groupId, channelId: channelId, messageId: messageId)
            .updateData([
                Message.Keys.media: urls,
                Message.Keys.mediaStatus: Message.MediaStatus.done.rawValue,
                Message.Keys.timestamp: String(Int64(Date().timeIntervalSince1970 * 1000)),
                Message.Keys.body: "[media message done]"
            ]) { err in
                semaphore.signal()
        }
        // Wait for document creation
        semaphore.wait()
    }
    
    /**
     Mark eror if upload fails. Currently this will mark a message as failed if just one out of all uploads fails.
     */
    func addMediaMessageError(
        groupId: String,
        channelId: String,
        messageId: String
    ) {
        messageDocumentReference(
            groupId: groupId,
            channelId: channelId,
            messageId: messageId
        ).updateData([
            Message.Keys.mediaStatus: Message.MediaStatus.error.rawValue
        ])
    }
    
    /**
     Creates a message that will only contain media files with the status *UPLOADING*
     */
    func createMediaMessage(
        groupId: String,
        channelId: String,
        media: [String]
    ) -> String? {
        let uid = self.getUserUid()
        let db = Firestore.firestore()
        let semaphore = DispatchSemaphore(value: 0)
        let ref: DocumentReference? = db.collection(Constants.groupsCollection)
            .document(groupId)
            .collection(Constants.channelsCollection)
            .document(channelId)
            .collection(Constants.messagesCollection)
            .addDocument(data: [
                Message.Keys.author: uid,
                Message.Keys.type: Message.Values.mediaType,
                Message.Keys.mediaStatus: Message.MediaStatus.uploading.rawValue,
                Message.Keys.media: media,
                Message.Keys.timestamp: String(Int64(Date().timeIntervalSince1970 * 1000)),
                Message.Keys.body: "[media message uploading]"
            ]) { err in
                semaphore.signal()
        }
        // Wait for document creation
        semaphore.wait()
        return ref?.documentID
    }
    
    // MARK: - USER
    
    /**
     Gets the user id from firebase
     */
    func getUserUid() -> String {
        let firebaseAuth = Auth.auth()
        let uid = firebaseAuth.currentUser!.uid
        return uid
    }
}

// MARK: Constants

private enum Constants {
    static let channelName = "de.janoodle.timy/upload_platform"
    static let uploadMethod = "uploadFiles"
    static let jpgExtension = ".jpg"
    
    static let keyGroupId = "groupId"
    static let keyChannelId = "channelId"
    static let keyFilePaths = "filePaths"
    static let keyLocalIdentifiers = "localIdentifiers"
    
    static let groupsCollection = "groups"
    static let channelsCollection = "channels"
    static let messagesCollection = "messages"
    
    static func messagePath(groupId: String, channelId: String, messageId: String) -> String {
        return Constants.groupsCollection
            + "\(groupId)/"
            + Constants.channelsCollection
            + "\(channelId)/"
            + Constants.messagesCollection
            + "/\(messageId)/"
    }
}

private enum Message {
    enum Keys {
        static let media = "media"
        static let mediaStatus = "media_status"
        static let timestamp = "timestamp"
        static let body = "body"
        static let type = "type"
        static let author = "author"
    }
    
    enum Values {
        static let mediaType = "MEDIA"
    }
    
    enum MediaStatus: String {
        case uploading = "UPLOADING"
        case done = "DONE"
        case error = "ERROR"
    }
}
