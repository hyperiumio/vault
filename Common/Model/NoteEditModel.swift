import Combine

class NoteEditModel: ObservableObject, Identifiable {
    
    @Published var note: Note
    
    var isComplete: Bool {
        return !note.isEmpty
    }
    
    var secureItem: SecureItem? {
        guard !note.isEmpty else {
            return nil
        }
        
        return SecureItem.note(note)
    }
    
    init(_ note: Note? = nil) {
        self.note = note ?? ""
    }
    
}
