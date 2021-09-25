import Foundation
import PDFKit

public func RestoreKitGenerate(title: String, secretKey: Data) throws -> Data {
    guard
        let data = CFDataCreateMutable(nil, 0),
        let consumer = CGDataConsumer(data: data),
        let context = CGContext(consumer: consumer, mediaBox: nil, nil)
    else {
        throw VisualizationError.creatingDrawingContextFailed
    }
    
    context.beginPDFPage(nil)

    let qrCode = try QRCode(from: secretKey)
    context.draw(qrCode, in: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    context.endPDFPage()
    context.closePDF()
    
    return data as Data
}
