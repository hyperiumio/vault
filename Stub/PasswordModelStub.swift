#if DEBUG
import Combine

class PasswordModelStub: PasswordModelRepresentable {
    
    @Published var password = ""
    
    func copyPasswordToPasteboard() {}
    
}
#endif
