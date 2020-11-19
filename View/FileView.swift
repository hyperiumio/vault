import Localization
import PDFKit
import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
struct FileView: View {
    
    private let item: FileItem
    
    init(_ item: FileItem) {
        self.item = item
    }
    
    var body: some View {
        Group {
            switch item.typeIdentifier {
            case let typeIdentifier where typeIdentifier.conforms(to: .image):
                if let image = UIImage(data: item.data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    UnrepresentableFileView(typeIdentifier)
                }
            case let typeIdentifier where typeIdentifier.conforms(to: .pdf):
                if let document = PDFDocument(data: item.data) {
                    NativePDFView(document)
                        .scaledToFit()
                } else {
                    UnrepresentableFileView(typeIdentifier)
                }
            default:
                UnrepresentableFileView(item.typeIdentifier)
            }
        }
        .listRowInsets(.zero)
    }
    
}

private struct UnrepresentableFileView: View {
    
    private let typeIdentifier: UTType
    
    init(_ typeIdentifier: UTType) {
        self.typeIdentifier = typeIdentifier
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            if let filenameExtension = typeIdentifier.preferredFilenameExtension {
                Text(filenameExtension)
                    .textCase(.uppercase)
            }
            
            Spacer()
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
struct FileViewPreview: PreviewProvider {
    
    static let pdf: FileItem = {
        let data = NSDataAsset(name: "PDFDummy")!.data
        return FileItem(data: data, typeIdentifier: .pdf)
    }()
    
    static let image: FileItem = {
        let data = NSDataAsset(name: "ImageDummy")!.data
        return FileItem(data: data, typeIdentifier: .image)
    }()
    
    static let unrepresentable: FileItem = {
        let data = Data()
        return FileItem(data: data, typeIdentifier: .epub)
    }()
    
    static var previews: some View {
        Group {
            List {
                Section {
                    FileView(unrepresentable)
                }
                
                Section {
                    FileView(image)
                }
                
                Section {
                    FileView(pdf)
                }
            }
            .preferredColorScheme(.light)
            
            List {
                Section {
                    FileView(unrepresentable)
                }
                
                Section {
                    FileView(image)
                }
                
                Section {
                    FileView(pdf)
                }
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
