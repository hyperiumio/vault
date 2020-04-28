import Combine

class NoteDisplayModel: ObservableObject, Identifiable {
        
    let note: String
    
    init(_ note: Note) {
        self.note = note
    }
}
