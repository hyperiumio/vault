import Localization
import SwiftUI

struct NoteEditView<Model>: View where Model: NoteEditModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            FieldLabel(LocalizedString.note)
            
            TextEditor(text: $model.text)
        }
    }
    
}


#if DEBUG
class NoteEditModelStub: NoteEditModelRepresentable {
    
    var text = ""
    
}

struct NoteEditViewProvider: PreviewProvider {
    
    static let model = NoteEditModelStub()
    
    static var previews: some View {
        NoteEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}

#endif
