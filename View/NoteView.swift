import Localization
import SwiftUI

struct NoteView: View {
    
    private let item: NoteItem
    
    init(_ item: NoteItem) {
        self.item = item
    }
    
    var body: some View {
        if let text = item.text {
            SecureItemTextField(LocalizedString.note, text: text)
        }
    }
    
}

#if DEBUG
struct NoteViewPreview: PreviewProvider {
    
    static let item = NoteItem(text: "foo\n\nbar")
    
    static var previews: some View {
        Group {
            List {
                NoteView(item)
            }
            .preferredColorScheme(.light)
            
            List {
                NoteView(item)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
