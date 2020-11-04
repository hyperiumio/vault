import Combine
import Pasteboard
import Store

protocol NoteModelRepresentable: ObservableObject, Identifiable {
    
    var text: String { get set }
    var item: NoteItem { get }
    
}

class NoteModel: NoteModelRepresentable {
    
    @Published var text: String
    
    var item: NoteItem {
        let text = self.text.isEmpty ? nil : self.text
        
        return NoteItem(text: text)
    }
    
    init(_ item: NoteItem) {
        self.text = item.text ?? ""
    }
    
}

#if DEBUG
class NoteModelStub: NoteModelRepresentable {
    
    @Published var text = ""
    
    var item: NoteItem {
        NoteItem(text: text)
    }
    
}
#endif
