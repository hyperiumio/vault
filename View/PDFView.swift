import SwiftUI

#if canImport(AppKit)
import AppKit
import Quartz

struct PDFView: NSViewRepresentable {
    
    let document: PDFDocument
    
    func makeNSView(context: Context) -> Quartz.PDFView {
        let pdfView = Quartz.PDFView()
        pdfView.document = document
        return pdfView
    }
    
    func updateNSView(_ pdfView: PDFKit.PDFView, context: Context) {}
    
}
#endif

#if canImport(UIKit)
import PDFKit
import UIKit

struct PDFView: UIViewRepresentable {
    
    let document: PDFDocument
    
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
#endif
