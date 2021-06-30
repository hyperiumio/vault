#if DEBUG
import SwiftUI

struct NoteInputPreview: PreviewProvider {
    
    static let state = NoteState()
    
    static var previews: some View {
        List {
            NoteInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            NoteInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
