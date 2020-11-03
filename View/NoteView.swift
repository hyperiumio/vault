import Localization
import SwiftUI

struct NoteDisplayView: View {
    
    private let item: NoteItem
    
    init(_ item: NoteItem) {
        self.item = item
    }
    
    var body: some View {
        if let text = item.text {
            SecureItemTextDisplayField(LocalizedString.note, text: text)
        }
    }
    
}
