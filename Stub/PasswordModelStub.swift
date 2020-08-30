#if DEBUG
import Combine
import Store

class PasswordModelStub: PasswordModelRepresentable {
    
    @Published var password: String
    
    var passwordItem: PasswordItem {
        PasswordItem(password: password)
    }
    
    init(password: String) {
        self.password = password
    }
    
    func copyPasswordToPasteboard() {}
    
}
#endif
