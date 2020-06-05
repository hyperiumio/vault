import Combine
import Store

class NoteDisplayModel: ObservableObject, Identifiable {
        
    var text: String { note.text }
    
    private let note: Note
    
    init(_ note: Note) {
        self.note = note
    }
}
