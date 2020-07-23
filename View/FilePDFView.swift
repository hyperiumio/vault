import SwiftUI

struct FilePDFView: View {
    
    let data: Data
    
    var body: some View {
        if let document = PDFDocument(data: data) {
            PDFView(document: document)
        } else {
            Text("?")
        }
    }
    
}

#if canImport(AppKit)
import Quartz

struct PDFView: NSViewRepresentable {
    
    let document: PDFDocument
    
    func makeNSView(context: Context) -> Quartz.PDFView {
        let pdfView = Quartz.PDFView()
        pdfView.document = document
        return pdfView
    }
    
    func updateNSView(_ nsView: Quartz.PDFView, context: Context) {}
    
}
#endif

#if canImport(UIKit)
import PDFKit

struct PDFView: UIViewRepresentable {
    
    let document: PDFDocument
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.document = document
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {}
    
}
#endif
