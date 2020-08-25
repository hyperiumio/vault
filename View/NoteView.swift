import Localization
import SwiftUI

struct NoteView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextEditorField(LocalizedString.note, text: $model.text, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}


#if DEBUG
struct NoteViewPreviews: PreviewProvider {
    
    static let model = NoteModelStub()
    @State static var isEditable = false
    
    static var previews: some View {
        NoteView(model, isEditable: $isEditable)
    }
    
}

#endif
