import Foundation
import Model

@MainActor
class LoginState: ObservableObject {
    
    @Published var username: String
    @Published var password: String
    @Published var url: String
    
    var item: LoginItem {
        let username = self.username.isEmpty ? nil : self.username
        let password = self.password.isEmpty ? nil : self.password
        let url = self.url.isEmpty ? nil : self.url
        
        return LoginItem(username: username, password: password, url: url)
    }
    
    init(_ item: LoginItem? = nil) {
        self.username = item?.username ?? ""
        self.password = item?.password ?? ""
        self.url = item?.url ?? ""
    }
    
}
