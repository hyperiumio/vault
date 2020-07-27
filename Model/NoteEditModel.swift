import Combine
import Store

class NoteEditModel: ObservableObject, Identifiable {
    
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
