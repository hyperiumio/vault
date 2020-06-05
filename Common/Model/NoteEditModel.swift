import Combine
import Store

class NoteEditModel: ObservableObject, Identifiable {
    
    @Published var text: String
    
    var isComplete: Bool { !text.isEmpty }
    
    var secureItem: SecureItem? {
        guard !text.isEmpty else {
            return nil
        }
        
        let note = Note(text: text)
        return SecureItem.note(note)
    }
    
    init(_ note: Note? = nil) {
        self.text = note?.text ?? ""
    }
    
}
