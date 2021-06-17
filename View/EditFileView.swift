import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct EditFileView<S>: View where S: FileStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        FileView(state.item)
    }
    
}

#if DEBUG
struct EditFileViewPreview: PreviewProvider {
    
    static let state: FileStateStub = {
        let data = NSDataAsset(name: "ImageDummy")!.data
        return FileStateStub(typeIdentifier: .image, data: data)
    }()
    
    static var previews: some View {
        List {
            EditFileView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
