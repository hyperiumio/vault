import Combine

class LoginEditModel: ObservableObject, Identifiable {
    
    @Published var user: String
    @Published var password: String
    
    var isComplete: Bool {
        return !user.isEmpty && !password.isEmpty
    }
    
    var secureItem: SecureItem? {
        guard !user.isEmpty, !password.isEmpty else {
            return nil
        }
            
        let login = Login(username: user, password: password)
        return SecureItem.login(login)
    }
    
    init(_ login: Login? = nil) {
        self.user = login?.username ?? ""
        self.password = login?.password ?? ""
    }
    
}
