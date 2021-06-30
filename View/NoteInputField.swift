import SwiftUI

struct NoteInputField: View {
    
    @ObservedObject private var state: NoteState
    
    init(_ state: NoteState) {
        self.state = state
    }
    
    var body: some View {
        Field(.note) {
            TextEditor(text: $state.text)
        }
    }
    
}
