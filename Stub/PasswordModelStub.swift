#if DEBUG
import Combine
import Store

class PasswordModelStub: PasswordModelRepresentable {
    
    @Published var password: String
    
    var item: PasswordItem {
        PasswordItem(password: password)
    }
    
    init(password: String) {
        self.password = password
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) {}
    
}
#endif
