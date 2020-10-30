import Combine
import Pasteboard
import Store

protocol NoteModelRepresentable: ObservableObject, Identifiable {
    
    var text: String { get set }
    var noteItem: NoteItem { get }
    
}

class NoteModel: NoteModelRepresentable {
    
    @Published var text: String
    
    var noteItem: NoteItem {
        let text = self.text.isEmpty ? nil : self.text
        
        return NoteItem(text: text)
    }
    
    init(_ noteItem: NoteItem) {
        self.text = noteItem.text ?? ""
    }
    
}
