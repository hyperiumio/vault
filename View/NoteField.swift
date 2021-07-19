import Model
import Pasteboard
import SwiftUI

struct NoteField: View {
    
    private let item: NoteItem
    
    init(_ item: NoteItem) {
        self.item = item
    }
    
    var body: some View {
        if let text = item.text {
            Button {
                Pasteboard.general.string = text
            } label: {
                Field(.note) {
                    Text(text)
                }
            }
            .buttonStyle(.message(.copied))
        }
        
    }
    
}
