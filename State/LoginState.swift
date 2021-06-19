import Foundation
import Model

@MainActor
protocol LoginStateRepresentable: ObservableObject, Identifiable {

    var username: String { get set }
    var password: String { get set }
    var url: String { get set}
    var item: LoginItem { get }
    
}

@MainActor
class LoginState: LoginStateRepresentable {
    
    @Published var username: String
    @Published var password: String
    @Published var url: String
    
    var item: LoginItem {
        let username = self.username.isEmpty ? nil : self.username
        let password = self.password.isEmpty ? nil : self.password
        let url = self.url.isEmpty ? nil : self.url
        
        return LoginItem(username: username, password: password, url: url)
    }
    
    init(_ item: LoginItem) {
        self.username = item.username ?? ""
        self.password = item.password ?? ""
        self.url = item.url ?? ""
    }
    
}

#if DEBUG
class LoginStateStub: LoginStateRepresentable {
    
    @Published var username = ""
    @Published var password = ""
    @Published var url = ""
    
    var item: LoginItem {
        LoginItem(username: username, password: password, url: url)
    }
    
}
#endif
