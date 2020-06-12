import Combine
import Store

class NoteDisplayModel: ObservableObject, Identifiable {
        
    var text: String { note.text }
    
    private let note: NoteItem
    
    init(_ note: NoteItem) {
        self.note = note
    }
}
