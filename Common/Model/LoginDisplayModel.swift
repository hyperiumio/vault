import Foundation
import Pasteboard
import Store

class LoginDisplayModel: ObservableObject, Identifiable {
    
    @Published var secureDisplay = true
    
    var username: String { login.username }
    var password: String { login.password }
    var url: String? { login.url }
    
    private let login: Login
    
    init(_ login: Login) {
        self.login = login
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password
    }
    
}
