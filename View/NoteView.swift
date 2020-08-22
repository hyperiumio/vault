import Localization
import SwiftUI

struct NoteView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject var model: Model
    @Binding var isEditable: Bool
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextEditorField(title: LocalizedString.note, text: $model.text, isEditable: $isEditable)
        }
    }
    
}


#if DEBUG
class NoteModelStub: NoteModelRepresentable {
    
    var text = """
    Title

    Body
    """
    
    func copyTextToPasteboard() {}
    
}

struct NoteViewPreviewProvider: PreviewProvider {
    
    static let model = NoteModelStub()
    @State static var isEditable = false
    
    static var previews: some View {
        NoteView(model: model, isEditable: $isEditable)
    }
    
}

#endif
