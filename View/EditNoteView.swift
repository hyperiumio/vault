import SwiftUI

#warning("Todo")
struct EditNoteView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        SecureItemField(.note) {
            TextEditor(text: $model.text)
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        SecureItemField(.note) {
            TextEditor(text: $model.text)
        }
    }
    #endif
    
}

#if DEBUG
struct EditNoteViewPreview: PreviewProvider {
    
    static let model = NoteModelStub()
    
    static var previews: some View {
        Group {
            List {
                EditNoteView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditNoteView(model)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
