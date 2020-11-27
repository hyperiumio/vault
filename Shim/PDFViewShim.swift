import PDFKit
import SwiftUI

#if os(iOS)
struct PDFViewShim: UIViewRepresentable {
    
    private let document: PDFDocument
    
    init(_ document: PDFDocument) {
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
struct PDFViewShim: NSViewRepresentable {
    
    private let document: PDFDocument
    
    init(_ document: PDFDocument) {
        self.document = document
    }
    
    func makeNSView(context: Context) -> PDFView {
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
    
    func updateNSView(_ nsView: PDFView, context: Context) {}
    
}
#endif
