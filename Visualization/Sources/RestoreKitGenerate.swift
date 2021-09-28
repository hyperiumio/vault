import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import PDFKit

public func RestoreKitGenerate(title: String, secretKey: Data) throws -> Data {
    let pdfWith = 8.27 * PDFContext.dpi
    let pdfHeight = 11.69 * PDFContext.dpi
    let pdfSize = CGSize(width: pdfWith, height: pdfHeight)
    
    return try PDFContext(size: pdfSize).draw { context in
        let textFrame = CGRect(origin: .zero, size: pdfSize).insetBy(dx: 20, dy: 60)
        let path = CGPath(rect: textFrame, transform: nil)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let stringAttributes = [
            .font: UIFont.systemFont(ofSize: 24),
            .paragraphStyle: paragraphStyle
        ] as [NSAttributedString.Key: Any]
        let title = NSAttributedString(string: title, attributes: stringAttributes)
        let framesetter = CTFramesetterCreateWithAttributedString(title)
        let framesetterFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, title.length), path, nil)
        CTFrameDraw(framesetterFrame, context)
        
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(secretKey, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else {
            throw VisualizationError.qrCodeGenerationFailed
        }
        let scale = (pdfWith / output.extent.size.width) * 2
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledOutput = output.transformed(by: transform)
        guard let qrCode = CIContext(options: nil).createCGImage(scaledOutput, from: scaledOutput.extent) else {
            throw VisualizationError.qrCodeGenerationFailed
        }
        let qrCodeWidth = CGFloat(qrCode.width) / 8
        let qrCodeHeight = CGFloat(qrCode.height) / 8
        let qrCodeX = (pdfWith - qrCodeWidth) / 2
        let qrCodeY = (pdfHeight - qrCodeHeight) / 2
        let qrCodeFrame = CGRect(x: qrCodeX, y: qrCodeY, width: qrCodeWidth, height: qrCodeHeight)
        context.draw(qrCode, in: qrCodeFrame)
    }
}
