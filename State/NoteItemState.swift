import Foundation
import Model

@MainActor
class NoteItemState: ObservableObject {
    
    @Published var text: String
    
    var item: NoteItem {
        NoteItem(text: text)
    }
    
    init(item: NoteItem? = nil) {
        self.text = item?.text ?? ""
    }
    
}
