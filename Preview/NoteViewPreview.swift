#if DEBUG
import SwiftUI

struct NoteViewPreview: PreviewProvider {
    
    static let model = NoteModelStub(text: "")
    @State static var isEditable = false
    
    static var previews: some View {
        NoteView(model, isEditable: $isEditable)
    }
    
}
#endif
