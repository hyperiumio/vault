#if DEBUG
import Combine

class LoginModelStub: LoginModelRepresentable {
    
    @Published var username = ""
    @Published var password = ""
    @Published var url = ""
    
    func copyUsernameToPasteboard() {}
    func copyPasswordToPasteboard() {}
    func copyURLToPasteboard() {}
    
}
#endif
