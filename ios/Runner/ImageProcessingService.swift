import UIKit
import func AVFoundation.AVMakeRect

private enum ImageProcessingConstants {
    static let maxImageSize = CGSize(width: 1080, height: 1080);
    static let imageDefaultCompression = CGFloat(0.9);
}

final class ImageProcessingService {
    /**
     Processes an image for a given URL by resizing and compressing it.
     If the image is smaller than the set maxAspectSize it will not be scaled up nor will it be compressed.
     
     - Parameter url: Image URL
     - Parameter maxAspectSize: Specifies the max with / height allowed for the given image. Default is 1080 x 1080.
     - Parameter compression: Compression for the image. From 0.0 to 1.0 (high to low)
     */
    static func processImageToJPEG(for url: URL, with maxAspectSize: CGSize = ImageProcessingConstants.maxImageSize, and compression: CGFloat = ImageProcessingConstants.imageDefaultCompression) -> Data? {
        return imageToJPEG(url: url, with: maxAspectSize, and: compression)
    }
    
    static func processImageToJPEG(for data: Data, with maxAspectSize: CGSize = ImageProcessingConstants.maxImageSize, and compression: CGFloat = ImageProcessingConstants.imageDefaultCompression) -> Data? {
        return imageToJPEG(for: data, with: maxAspectSize, and: compression)
    }
}

private extension ImageProcessingService {
    static func imageToJPEG(for data: Data? = nil,
                            url: URL? = nil,
                            with maxAspectSize: CGSize = ImageProcessingConstants.maxImageSize,
                            and compression: CGFloat = ImageProcessingConstants.imageDefaultCompression) -> Data? {
        var loadedImage: UIImage? = nil;
        if let imageData = data, let uiImage = UIImage(data: imageData) {
            loadedImage = uiImage       
        } else if let imageURL = url, let uiImage = UIImage(contentsOfFile: imageURL.path) {
            loadedImage = uiImage
        }
        
        guard let image = loadedImage else {
            return nil
        }
        
        guard image.size.width > maxAspectSize.width || image.size.height > maxAspectSize.height else {
            return UIImageJPEGRepresentation(image, 1)
        }
        
        let aspectRect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: maxAspectSize))
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.scale = 1.0 // We'd like this to be device independant
        
        let renderer = UIGraphicsImageRenderer(size: aspectRect.size, format: rendererFormat)
        
        return renderer.jpegData(withCompressionQuality: compression) { (context) in
            image.draw(in: CGRect(origin: .zero, size: aspectRect.size))
        }
    }
}
