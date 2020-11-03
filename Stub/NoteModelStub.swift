#if DEBUG
import Combine
import Store

class NoteModelStub: NoteModelRepresentable {
    
    @Published var text: String
    
    var item: NoteItem {
        NoteItem(text: text)
    }
    
    init(text: String) {
        self.text = text
    }
    
}
#endif
