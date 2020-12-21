import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct EditFileView<Model>: View where Model: FileModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        FileView(model.item)
    }
    
}

#if DEBUG
struct EditFileViewPreview: PreviewProvider {
    
    static let model: FileModelStub = {
        let data = NSDataAsset(name: "ImageDummy")!.data
        return FileModelStub(typeIdentifier: .image, data: data)
    }()
    
    static var previews: some View {
        Group {
            List {
                EditFileView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditFileView(model)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
