import Localization
import PDFKit
import SwiftUI

struct FileDisplayView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Text("Show File")
    }
    
}

struct FileEditView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var isImporting = false
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            switch model.fileStatus {
            case .empty:
                Button {
                    isImporting = true
                } label: {
                    Text("Select file")
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                }
            case .loading:
                ProgressView()
            case .loaded:
                Text("data")
            }
        }
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.item]) { result in
            switch result {
            case .success(let url):
                model.loadFile(at: url)
            case .failure:
                return // present error
            }
        }
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
