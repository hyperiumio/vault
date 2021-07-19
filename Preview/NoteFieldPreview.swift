#if DEBUG
import Model
import SwiftUI

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
