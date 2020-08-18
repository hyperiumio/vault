import Localization
import SwiftUI

struct NoteDisplayView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        SecureItemDisplayField(title: LocalizedString.note, content: model.text)
    }
    
}

#if DEBUG
class NoteDisplayModelStub: NoteModelRepresentable {
    
    var text = """
    Title

    Body
    """
    
    func copyTextToPasteboard() {}
    
}

struct NoteDisplayViewPreview: PreviewProvider {
    
    static let model = NoteDisplayModelStub()
    
    static var previews: some View {
        NoteView(model: model)
    }
    
}
#endif
