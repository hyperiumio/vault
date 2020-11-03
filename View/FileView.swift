import Localization
import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct FileView: View {
    
    private let item: FileItem
    
    init(_ item: FileItem) {
        self.item = item
    }
    
    var body: some View {
        switch item.typeIdentifier {
        case let typeIdentifier where typeIdentifier.conforms(to: .image):
            if let image = UIImage(data: item.data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                UnrepresentableFileView()
            }
        case let typeIdentifier where typeIdentifier.conforms(to: .pdf):
            if let document = PDFDocument(data: item.data) {
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

