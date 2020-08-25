#if DEBUG
import Combine

class CustomItemModelStub: CustomItemModelRepresentable {

    @Published var name = ""
    @Published var value = ""
    
    func copyValueToPasteboard() {}
    
}
#endif
