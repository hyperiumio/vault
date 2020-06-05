import Foundation
import Pasteboard

class LoginDisplayModel: ObservableObject, Identifiable {
    
    @Published var secureDisplay = true
    
    var username: String {
        return login.username
    }
    
    var password: String {
        return login.password
    }
    
    var url: String {
        return login.url
    }
    
    private let login: Login
    
    init(_ login: Login) {
        self.login = login
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password
    }
    
}
