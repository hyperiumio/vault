import Localization
import PDFKit
import SwiftUI

struct FileDisplayView<Model>: View where Model: FileDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemDisplayField(title: LocalizedString.title, content: model.filename)
            
            switch model.fileFormat {
            case .unrepresentable:
                FileGenericView()
            case .pdf:
                FilePDFView(data: model.fileData)
            case .image:
                FileImageView(data: model.fileData)
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
            Vault.PDFView(document: document)
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

#if DEBUG
class FileDisplayModelStub: FileDisplayModelRepresentable {
    
    var filename = "Lena"
    var fileFormat = FileFormat.image
    var fileData = NSDataAsset(name: "ImageDummy")?.data ?? Data()
    
}

struct FileDisplayViewProvider: PreviewProvider {
    
    static let model = FileDisplayModelStub()
    
    static var previews: some View {
        FileDisplayView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
