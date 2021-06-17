import SwiftUI

struct EditNoteView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        ItemField(.note) {
            TextEditor(text: $model.text)
        }
    }
    
}

#if DEBUG
struct EditNoteViewPreview: PreviewProvider {
    
    static let model = NoteModelStub()
    
    static var previews: some View {
        List {
            EditNoteView(model)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
