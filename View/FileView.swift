import Localization
import PDFKit
import SwiftUI

struct FileView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemField(LocalizedString.filename, text: $model.name, isEditable: isEditable) {
                switch (model.data, model.format) {
                case (nil, _):
                    Text("Select File")
                case (let data?, .pdf):
                    FilePDFView(data: data)
                case (let data?, .image):
                    FileImageView(data: data)
                case (.some, .unrepresentable):
                    FileGenericView()
                }
            }
        }
    }
    
}

private struct FileGenericView: View {
    
    var body: some View {
        Image(systemName: "doc.fill")
    }
    
}

private struct FilePDFView: View {
    
    let data: Data
    
    var body: some View {
        if let document = PDFDocument(data: data) {
            PDF(document)
        } else {
            FileGenericView()
        }
    }
    
}

#if canImport(AppKit)
private struct FileImageView: View {
    
    let data: Data
    
    var body: some View {
        if let nativeImage = NSImage(data: data) {
            Image(nsImage: nativeImage)
        } else {
            FileGenericView()
        }
    }
    
}
#endif

#if os(iOS)
private struct FileImageView: View {
    
    let data: Data

    var body: some View {
        if let nativeImage = UIImage(data: data) {
            Image(uiImage: nativeImage)
                .resizable()
                .scaledToFit()
        } else {
            FileGenericView()
        }
    }
    
}
#endif
