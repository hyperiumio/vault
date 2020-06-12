import Foundation
import Pasteboard
import Store

class LoginDisplayModel: ObservableObject, Identifiable {
    
    @Published var secureDisplay = true
    
    var username: String { login.username }
    var password: String { login.password }
    var url: String? { login.url }
    
    private let login: LoginItem
    
    init(_ login: LoginItem) {
        self.login = login
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password
    }
    
}
