import Combine
import Store

class NoteEditModel: ObservableObject, Identifiable {
    
    @Published var text: String
    
    var isComplete: Bool { !text.isEmpty }
    
    var secureItem: SecureItem? {
        guard !text.isEmpty else {
            return nil
        }
        
        let note = NoteItem(text: text)
        return SecureItem.note(note)
    }
    
    init(_ note: NoteItem? = nil) {
        self.text = note?.text ?? ""
    }
    
}
