import Foundation

class LoginDisplayModel: ObservableObject, Identifiable {
    
    @Published var secureDisplay = true
    
    var username: String {
        return login.username
    }
    
    var password: String {
        return login.password
    }
    
    private let login: Login
    
    init(_ login: Login) {
        self.login = login
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password
    }
    
}
