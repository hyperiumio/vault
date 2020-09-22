import SwiftUI

#if canImport(AppKit)
import AppKit
import Quartz

struct PDF: NSViewRepresentable {
    
    private let document: PDFDocument
    
    init(_ document: PDFDocument) {
        self.document = document
    }
    
    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        return pdfView
    }
    
    func updateNSView(_ pdfView: PDFView, context: Context) {}
    
}
#endif

#if canImport(UIKit)
import PDFKit
import UIKit

struct PDF: UIViewRepresentable {
    
    private let document: PDFDocument
    
    init(_ document: PDFDocument) {
        self.document = document
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.pageShadowsEnabled = false
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.sizeToFit()
        pdfView.document = document
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {}
    
}
#endif
