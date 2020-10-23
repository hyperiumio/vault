import SwiftUI
import PDFKit

struct PDFView: UIViewRepresentable {
    
    private let document: PDFDocument
    
    init(_ document: PDFDocument) {
        self.document = document
    }
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.pageShadowsEnabled = false
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.sizeToFit()
        pdfView.document = document
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {}
    
}

