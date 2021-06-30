#if DEBUG
import SwiftUI

struct NoteFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            NoteField(text: "foo\n\nbar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            NoteField(text: "foo\n\nbar")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
