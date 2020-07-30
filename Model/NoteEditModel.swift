import Combine
import Store

protocol NoteEditModelRepresentable: ObservableObject, Identifiable {
    
    var text: String { get set }
    
}

class NoteEditModel: NoteEditModelRepresentable {
    
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
    
}
