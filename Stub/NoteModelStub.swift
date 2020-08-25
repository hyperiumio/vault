#if DEBUG
import Combine

class NoteModelStub: NoteModelRepresentable {
    
    @Published var text = ""
    
    func copyTextToPasteboard() {}
    
}
#endif
