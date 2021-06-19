import PDFKit
import SwiftUI
import UniformTypeIdentifiers
#warning("TODO")
struct FileInputField<S>: View where S: FileStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        fatalError()
        /*
        FileView(state.item)*/
    }
    
}

#if DEBUG
struct FileInputFieldPreview: PreviewProvider {
    
    static let state: FileStateStub = {
        let data = NSDataAsset(name: "ImageDummy")!.data
        return FileStateStub(typeIdentifier: .image, data: data)
    }()
    
    static var previews: some View {
        List {
            FileInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
