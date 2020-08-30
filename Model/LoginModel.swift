import Combine
import Pasteboard
import Store

protocol LoginModelRepresentable: ObservableObject, Identifiable {

    var username: String { get set }
    var password: String { get set }
    var url: String { get set}
    var loginItem: LoginItem { get }
    
    func copyUsernameToPasteboard()
    func copyPasswordToPasteboard()
    func copyURLToPasteboard()
    
}

class LoginModel: LoginModelRepresentable {
    
    @Published var username: String
    @Published var password: String
    @Published var url: String
    
    var loginItem: LoginItem {
        LoginItem(username: username, password: password, url: url)
    }
    
    init(_ loginItem: LoginItem) {
        self.username = loginItem.username
        self.password = loginItem.password
        self.url = loginItem.url
    }
    
    init() {
        self.username = ""
        self.password = ""
        self.url = ""
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
