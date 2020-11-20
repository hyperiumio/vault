import PDFKit
import SwiftUI

#if os(iOS)
struct NativePDFView: UIViewRepresentable {
    
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
struct NativePDFView: NSViewRepresentable {
    
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

#if DEBUG
struct PDFViewPreview: PreviewProvider {
    
    static let document: PDFDocument = {
        let data = NSDataAsset(name: "PDFDummy")!.data
        return PDFDocument(data: data)!
    }()
    
    static var previews: some View {
        Group {
            NativePDFView(document)
                .preferredColorScheme(.light)
            
            NativePDFView(document)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
