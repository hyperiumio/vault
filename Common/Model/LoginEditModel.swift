import Combine
import Store

class LoginEditModel: ObservableObject, Identifiable {
    
    @Published var user: String
    @Published var password: String
    @Published var url: String
    
    var isComplete: Bool { !user.isEmpty && !password.isEmpty }
    
    var secureItem: SecureItem? {
        guard !user.isEmpty, !password.isEmpty else {
            return nil
        }
            
        let login = LoginItem(username: user, password: password, url: url)
        return SecureItem.login(login)
    }
    
    init(_ login: LoginItem? = nil) {
        self.user = login?.username ?? ""
        self.password = login?.password ?? ""
        self.url = login?.url ?? ""
    }
    
}
