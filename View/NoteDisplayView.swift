import Localization
import SwiftUI

struct NoteDisplayView<Model>: View where Model: NoteDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        SecureItemDisplayField(title: LocalizedString.note, content: model.text)
    }
    
}

#if DEBUG
class NoteDisplayModelStub: NoteDisplayModelRepresentable {
    
    var text = """
    Title

    Body
    """
    
    func copyTextToPasteboard() {}
    
}

struct NoteDisplayViewPreview: PreviewProvider {
    
    static let model = NoteDisplayModelStub()
    
    static var previews: some View {
        NoteDisplayView(model: model)
    }
    
}
#endif
