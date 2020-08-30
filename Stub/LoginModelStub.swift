#if DEBUG
import Combine
import Store

class LoginModelStub: LoginModelRepresentable {
    
    @Published var username: String
    @Published var password: String
    @Published var url: String
    
    var loginItem: LoginItem {
        LoginItem(username: username, password: password, url: url)
    }
    
    init(username: String, password: String, url: String) {
        self.username = username
        self.password = password
        self.url = url
    }
    
    func copyUsernameToPasteboard() {}
    func copyPasswordToPasteboard() {}
    func copyURLToPasteboard() {}
    
}
#endif
