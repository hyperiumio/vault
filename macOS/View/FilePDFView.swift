import PDFKit
import SwiftUI

struct FilePDFView: View {
    
    let data: Data
    
    var body: some View {
        guard let document = PDFDocument(data: data) else {
            return Text("?").eraseToAnyView()
        }
        
        return PDFView(document: document).eraseToAnyView()
    }
    
}

private struct PDFView: NSViewRepresentable {
    
    let document: PDFDocument
    
    func makeNSView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.document = document
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFKit.PDFView, context: Context) {}
    
}
