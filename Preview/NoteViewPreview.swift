#if DEBUG
import SwiftUI

struct NoteViewPreview: PreviewProvider {
    
    static let model = NoteModelStub(text: "")
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            NoteView(model, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            NoteView(model, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
