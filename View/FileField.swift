import SwiftUI
import UniformTypeIdentifiers
import PDFKit
#warning("Todo")
struct FileField: View {
    
    private let data: Data?
    private let typeIdentifier: UTType?
    
    init(data: Data?, typeIdentifier: UTType?) {
        self.data = data
        self.typeIdentifier = typeIdentifier
    }
    
    var body: some View {
        /*
        Group {
            switch typeIdentifier {
            case let typeIdentifier where typeIdentifier.conforms(to: .image):
                #if os(iOS)
                if let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    UnrepresentableFileView(typeIdentifier)
                }
                #endif
                
                #if os(macOS)
                if let image = NSImage(data: item.data) {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    UnrepresentableFileView(typeIdentifier)
                }
                #endif
            case let typeIdentifier where typeIdentifier.conforms(to: .pdf):
                if let document = PDFView.Document(data: data) {
                    PDFView(document)
                        .scaledToFit()
                } else {
                    UnrepresentableFileView(typeIdentifier)
                }
            default:
                UnrepresentableFileView(typeIdentifier)
            }
        }
         */
        fatalError()
    }
    
}

private struct UnrepresentableFileView: View {
    
    private let typeIdentifier: UTType
    
    init(_ typeIdentifier: UTType) {
        self.typeIdentifier = typeIdentifier
    }
    
    var body: some View {
        if let filenameExtension = typeIdentifier.preferredFilenameExtension {
            Text(filenameExtension)
                .textCase(.uppercase)
        }
    }
    
}
