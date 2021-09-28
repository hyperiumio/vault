import Foundation
import PDFKit

struct PDFContext {
    
    let size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    func draw(drawing: (CGContext) throws -> Void) throws -> Data {
        var mediaBox = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard
            let data = CFDataCreateMutable(nil, 0),
            let consumer = CGDataConsumer(data: data),
            let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil)
        else {
            throw VisualizationError.creatingDrawingContextFailed
        }
        
        context.beginPDFPage(nil)
        try drawing(context)
        context.endPDFPage()
        context.closePDF()
        
        return data as Data
    }
    
}

extension PDFContext {
    
    static var dpi: CGFloat { 72 }
    
}
