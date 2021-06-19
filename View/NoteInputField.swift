import SwiftUI

struct NoteInputField<NoteInputState>: View where NoteInputState: NoteStateRepresentable {
    
    @ObservedObject private var state: NoteInputState
    
    init(_ state: NoteInputState) {
        self.state = state
    }
    
    var body: some View {
        Field(.note) {
            TextEditor(text: $state.text)
        }
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
