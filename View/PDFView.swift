import PDFKit
import SwiftUI

#if os(iOS)
struct PDFView: View {
    
    private let document: PDFDocument
    
    private var aspectRatio: CGFloat {
        guard let size = document.page(at: 0)?.bounds(for: .mediaBox).size else {
            return 1
        }
        
        return size.height / size.width
    }
    
    init(_ document: PDFDocument) {
        self.document = document
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            NativePDFView(document)
                .frame(width: geometry.size.width, height: geometry.size.width * aspectRatio)
        }
    }
    
}
#endif

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
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {}
    
}
#endif

#if os(iOS) && DEBUG
struct PDFPreview: PreviewProvider {
    
    static let document: PDFDocument = {
        let data = NSDataAsset(name: "PDFDummy")!.data
        return PDFDocument(data: data)!
    }()
    
    static var previews: some View {
        Group {
            PDFView(document)
                .preferredColorScheme(.light)
            
            PDFView(document)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
