import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct FileInputField: View {
    
    @ObservedObject private var state: FileItemState
    
    init(_ state: FileItemState) {
        self.state = state
    }
    
    var body: some View {
        Text("missing")
    }
    
}

#if DEBUG
struct FileInputFieldPreview: PreviewProvider {
    
    static let state = FileItemState()
    
    static var previews: some View {
        List {
            FileInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
