import Foundation
import Model

@MainActor
class NoteState: ObservableObject {
    
    @Published var text: String
    
    var item: NoteItem {
        let text = self.text.isEmpty ? nil : self.text
        
        return NoteItem(text: text)
    }
    
    init(_ item: NoteItem? = nil) {
        self.text = item?.text ?? ""
    }
    
}
