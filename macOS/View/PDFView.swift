import PDFKit
import SwiftUI

struct PDFView: NSViewRepresentable {
    
    let document: PDFDocument
    
    func makeNSView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.document = document
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFKit.PDFView, context: Context) {}
    
}
