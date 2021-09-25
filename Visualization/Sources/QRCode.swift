import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

func QRCode(from data: Data) throws -> CGImage {
    let filter = CIFilter.qrCodeGenerator()
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("H", forKey: "inputCorrectionLevel")
    
    let scale = CGAffineTransform(scaleX: 1, y: 1)
    
    guard
        let output = filter.outputImage?.transformed(by: scale),
        let image = CIContext(options: nil).createCGImage(output, from: output.extent)
    else {
        throw VisualizationError.qrCodeGenerationFailed
    }
    
    return image
}
