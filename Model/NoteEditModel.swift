import Combine
import Store

class NoteEditModel: ObservableObject, Identifiable {
    
    @Published var text: String
    
    var isComplete: Bool { !text.isEmpty }
    
    var secureItem: SecureItem? {
        guard isComplete else { return nil }
        
        let note = NoteItem(text: text)
        return SecureItem.note(note)
    }
    
    init(_ note: NoteItem) {
        self.text = note.text
    }
    
    init() {
        self.text = ""
    }
    
}
