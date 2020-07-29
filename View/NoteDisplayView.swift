import Localization
import SwiftUI

struct NoteDisplayView<Model>: View where Model: NoteDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Section {
            SecureItemDisplayField(title: LocalizedString.note, content: model.text)
        }
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
    
    #if os(macOS)
    static var previews: some View {
        List {
            NoteDisplayView(model: model)
        }
    }
    #endif
    
    #if os(iOS)
    static var previews: some View {
        List {
            NoteDisplayView(model: model)
        }
        .listStyle(GroupedListStyle())
    }
    #endif
    
}
#endif
