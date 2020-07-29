import Foundation
import Pasteboard
import Store

protocol LoginDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var username: String { get }
    var password: String { get }
    var url: String { get }
    
    func copyUsernameToPasteboard()
    func copyPasswordToPasteboard()
    func copyURLToPasteboard()
    
}

class LoginDisplayModel: LoginDisplayModelRepresentable {
    
    var username: String { loginItem.username }
    var password: String { loginItem.password }
    var url: String { loginItem.url }
    
    private let loginItem: LoginItem
    
    init(_ loginItem: LoginItem) {
        self.loginItem = loginItem
    }
    
    func copyUsernameToPasteboard() {
        Pasteboard.general.string = username
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password
    }
    
    func copyURLToPasteboard() {
        Pasteboard.general.string = url
    }
    
}
