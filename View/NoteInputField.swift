import Resource
import SwiftUI

struct NoteInputField: View {
    
    @ObservedObject private var state: NoteItemState
    
    init(_ state: NoteItemState) {
        self.state = state
    }
    
    var body: some View {
        Field(Localized.note) {
            TextEditor(text: $state.text)
        }
    }
    
}
