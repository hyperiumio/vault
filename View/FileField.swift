import Common
import Model
import SwiftUI
import UniformTypeIdentifiers

struct FileField: View {
    
    private let item: FileItem?
    
    init(_ item: FileItem) {
        self.item = item
    }
    
    init() {
        self.item = nil
    }
    
    var body: some View {
        switch item {
        case let item? where item.type.conforms(to: .image):
            #if os(iOS)
            if let image = UIImage(data: item.data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                UnrepresentableFileView(item.type)
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
        case let item? where item.type.conforms(to: .pdf):
            if let document = PDFView.Document(data: item.data) {
                PDFView(document)
                    .scaledToFit()
            } else {
                UnrepresentableFileView(item.type)
            }
        default:
            UnrepresentableFileView(item?.type ?? .item)
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
