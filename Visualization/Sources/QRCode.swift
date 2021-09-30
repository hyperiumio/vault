import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation

public func QRCode(data: Data) throws -> Data {
    let filter = CIFilter.qrCodeGenerator()
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("H", forKey: "inputCorrectionLevel")
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    guard
        let output = filter.outputImage?.transformed(by: transform),
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
        let image = CIContext().heifRepresentation(of: output, format: .RGBA8, colorSpace: colorSpace)
    else {
        throw VisualizationError.qrCodeGenerationFailed
    }
    
    return image
}
