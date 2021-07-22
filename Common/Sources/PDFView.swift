import PDFKit
import SwiftUI

#if os(iOS)
public struct PDFView: UIViewRepresentable {
    
    private let document: Document
    
    public init(_ document: Document) {
        self.document = document
    }
    
    public func makeUIView(context: Context) -> PDFKit.PDFView {
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
    
    public func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {}
    
}
#endif

#if os(macOS)
public struct PDFView: NSViewRepresentable {
    
    private let document: Document
    
    public init(_ document: Document) {
        self.document = document
    }
    
    public func makeNSView(context: Context) -> PDFKit.PDFView {
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
    
    public func updateNSView(_ nsView: PDFKit.PDFView, context: Context) {}
    
}
#endif

extension PDFView {
    
    public typealias Document = PDFKit.PDFDocument
    
}
