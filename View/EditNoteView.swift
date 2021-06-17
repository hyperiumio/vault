import SwiftUI

struct EditNoteView<S>: View where S: NoteStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        ItemField(.note) {
            TextEditor(text: $state.text)
        }
    }
    
}

#if DEBUG
struct EditNoteViewPreview: PreviewProvider {
    
    static let state = NoteStateStub()
    
    static var previews: some View {
        List {
            EditNoteView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
