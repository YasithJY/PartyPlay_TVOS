import SwiftUI
import CoreImage.CIFilterBuiltins

/// Generates valid QR code images using Apple CoreImage CIFilter.
public final class QRCodeService {
    public static let shared = QRCodeService()
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    public init() {}
    
    /// Generates an Image from a given URL or text string.
    public func generateQRCode(from string: String, size: CGSize = CGSize(width: 260, height: 260)) -> Image? {
        guard let data = string.data(using: .utf8) else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter.outputImage else { return nil }
        
        let scaleX = size.width / outputImage.extent.size.width
        let scaleY = size.height / outputImage.extent.size.height
        let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        guard let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) else {
            return nil
        }
        
        #if canImport(UIKit)
        let uiImage = UIImage(cgImage: cgImage)
        return Image(uiImage: uiImage)
        #else
        return nil
        #endif
    }
}
