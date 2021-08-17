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

#if DEBUG
struct NoteFieldPreview: PreviewProvider {
    
    static let item = NoteItem(text: "foo\n\nbar")
    
    static var previews: some View {
        List {
            NoteField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            NoteField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
