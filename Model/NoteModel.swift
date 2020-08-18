import Combine
import Pasteboard
import Store

protocol NoteModelRepresentable: ObservableObject, Identifiable {
    
    var text: String { get set }
    
    func copyTextToPasteboard()
    
}

class NoteModel: NoteModelRepresentable {
    
    @Published var text: String
    
    var noteItem: NoteItem {
        NoteItem(text: text)
    }
    
    init(_ noteItem: NoteItem) {
        self.text = noteItem.text
    }
    
    init() {
        self.text = ""
    }
    
    func copyTextToPasteboard() {
        Pasteboard.general.string = text
    }
    
}
