#if DEBUG
import SwiftUI

struct NoteInputPreview: PreviewProvider {
    
    static let noteState = NoteState()
    
    static var previews: some View {
        List {
            NoteInputField(noteState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            NoteInputField(noteState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
