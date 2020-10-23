import PDFKit
import UniformTypeIdentifiers
import SwiftUI

struct FileView: View {
    
    private let data: Data
    private let type: UTType
    
    init(_ data: Data, type: UTType) {
        self.data = data
        self.type = type
    }
    
    var body: some View {
        switch type {
        case let type where type.conforms(to: .image):
            if let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                UnrepresentableFileView()
            }
        case let type where type.conforms(to: .pdf):
            if let document = PDFDocument(data: data) {
                PDFView(document)
            } else {
                UnrepresentableFileView()
            }
        default:
            UnrepresentableFileView()
        }
    }
    
}

private struct UnrepresentableFileView: View {
    
    var body: some View {
        Text("?")
    }
    
}
