import Foundation
import AVFoundation
import Photos

final class PermissionService {
    static let shared = PermissionService()
    private var permissionChannel: FlutterMethodChannel?
    
    enum AccessStatus: String {
        case denied = "DENIED"
        case authorized = "AUTHORIZED"
    }
    
    private init() {}
    
    func configureFlutterHandler(flutterBinaryMessenger: FlutterBinaryMessenger) {
        permissionChannel = FlutterMethodChannel(name: "de.janoodle.timy/permission-ios", binaryMessenger: flutterBinaryMessenger)
        
        permissionChannel?.setMethodCallHandler { [weak self] (flutterCall, flutterResult) in
            let flutterArguments = flutterCall.arguments as? NSDictionary
            guard let permissionType = flutterArguments?.value(forKey: "permissionType") as? String else { return }
            
            switch flutterCall.method {
            case "requestPermission":
                switch permissionType {
                case "CAMERA":
                    self?.requestCamera(completion: { (accessStatus) in
                        flutterResult(accessStatus.rawValue)
                    })
                case "PHOTOS":
                    self?.requestPhotos(completion: { (accessStatus) in
                        flutterResult(accessStatus.rawValue)
                    })
                default: flutterResult(FlutterMethodNotImplemented)
                }
            
            default: flutterResult(FlutterMethodNotImplemented)
            }
        }
    }
}

// MARK: Private PermissionService

private extension PermissionService {
    func requestPhotos(completion: @escaping (AccessStatus) -> Void) {
        let photoAccessStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAccessStatus {
        case .authorized:
            completion(.authorized)
        case .denied, .restricted:
            completion(.denied)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                completion(status == .authorized ? .authorized : .denied)
            })
        }
    }
    
    func requestCamera(completion: @escaping (AccessStatus) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        // Previously granted
        case .authorized: completion(.authorized)
            
        // Ask for access
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted ? .authorized : .denied)
            }
            
        // Denied or restricted (by device) access
        case .denied, .restricted: completion(.denied)
        }
    }
}
