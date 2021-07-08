import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct FileField: View {
    
    private let value: (data: Data, type: UTType)?
    
    init(data: Data, type: UTType) {
        self.value = (data: data, type: type)
    }
    
    init() {
        self.value = nil
    }
    
    var body: some View {
        switch value {
        case let value? where value.type.conforms(to: .image):
            #if os(iOS)
            if let image = UIImage(data: value.data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                UnrepresentableFileView(value.type)
            }
            #endif
            
            #if os(macOS)
            if let image = NSImage(data: value.data) {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                UnrepresentableFileView(value.type)
            }
            #endif
        case let value? where value.type.conforms(to: .pdf):
            if let document = PDFView.Document(data: value.data) {
                PDFView(document)
                    .scaledToFit()
            } else {
                UnrepresentableFileView(value.type)
            }
        default:
            UnrepresentableFileView(value?.type ?? .item)
        }
    }
    
}

private struct UnrepresentableFileView: View {
    
    private let type: UTType
    
    init(_ type: UTType) {
        self.type = type
    }
    
    var body: some View {
        if let filenameExtension = type.preferredFilenameExtension {
            Text(filenameExtension)
                .textCase(.uppercase)
        } else {
            Text(type.description)
        }
    }
    
}
