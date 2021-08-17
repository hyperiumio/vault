import SwiftUI

struct NoteInputField: View {
    
    @ObservedObject private var state: NoteItemState
    
    init(_ state: NoteItemState) {
        self.state = state
    }
    
    var body: some View {
        Field(.note) {
            TextEditor(text: $state.text)
        }
    }
    
}

#if DEBUG
struct NoteInputFieldPreview: PreviewProvider {
    
    static let state = NoteItemState()
    
    static var previews: some View {
        List {
            NoteInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            NoteInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
