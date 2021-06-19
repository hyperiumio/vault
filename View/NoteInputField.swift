import SwiftUI
#warning("TODO")
struct NoteInputField<S>: View where S: NoteStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        fatalError()
        /*
        Field(.note) {
            TextEditor(text: $state.text)
        }
         */
    }
    
}

#if DEBUG
struct NoteInputPreview: PreviewProvider {
    
    static let state = NoteStateStub()
    
    static var previews: some View {
        List {
            NoteInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
