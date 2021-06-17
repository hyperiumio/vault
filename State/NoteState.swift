import Combine
import Pasteboard
import Model

@MainActor
protocol NoteStateRepresentable: ObservableObject, Identifiable {
    
    var text: String { get set }
    var item: NoteItem { get }
    
}

@MainActor
class NoteState: NoteStateRepresentable {
    
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
class NoteStateStub: NoteStateRepresentable {
    
    @Published var text = ""
    
    var item: NoteItem {
        NoteItem(text: text)
    }
    
}
#endif
