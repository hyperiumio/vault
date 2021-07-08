import PDFKit
import SwiftUI

#if os(iOS)
struct PDFView: UIViewRepresentable {
    
    private let document: Document
    
    init(_ document: Document) {
        self.document = document
    }
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.pageShadowsEnabled = false
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.pageBreakMargins = .zero
        pdfView.document = document
        pdfView.backgroundColor = .clear
        pdfView.interpolationQuality = .high
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {}
    
}
#endif

#if os(macOS)
struct PDFView: NSViewRepresentable {
    
    private let document: Document
    
    init(_ document: Document) {
        self.document = document
    }
    
    func makeNSView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.pageShadowsEnabled = false
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.pageBreakMargins = NSEdgeInsetsZero
        pdfView.document = document
        pdfView.backgroundColor = .clear
        pdfView.interpolationQuality = .high
        
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFKit.PDFView, context: Context) {}
    
}
#endif

extension PDFView {
    
    typealias Document = PDFKit.PDFDocument
    
}
