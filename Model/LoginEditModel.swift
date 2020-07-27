import Combine
import Store

class LoginEditModel: ObservableObject, Identifiable {
    
    @Published var user: String
    @Published var password: String
    @Published var url: String
    
    var loginItem: LoginItem {
        LoginItem(username: user, password: password, url: url)
    }
    
    init(_ loginItem: LoginItem) {
        self.user = loginItem.username
        self.password = loginItem.password
        self.url = loginItem.url ?? ""
    }
    
    init() {
        self.user = ""
        self.password = ""
        self.url = ""
    }
    
}
