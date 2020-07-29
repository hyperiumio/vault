import Combine
import Pasteboard
import Store

protocol NoteDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var text: String { get }
    
    func copyTextToPasteboard()
    
}

class NoteDisplayModel: NoteDisplayModelRepresentable {
        
    var text: String { noteItem.text }
    
    private let noteItem: NoteItem
    
    init(_ noteItem: NoteItem) {
        self.noteItem = noteItem
    }
    
    func copyTextToPasteboard() {
        Pasteboard.general.string = text
    }
    
}
