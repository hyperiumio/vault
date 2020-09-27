import Localization
import PDFKit
import SwiftUI

struct FileDisplayView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemDisplayField(LocalizedString.filename) {
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

struct FileEditView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Text("foo")
    }
    
}

struct FileGenericView: View {
    
    var body: some View {
        Image(systemName: "doc.fill")
    }
    
}

struct FilePDFView: View {
    
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
struct FileImageView: View {
    
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
struct FileImageView: View {
    
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
