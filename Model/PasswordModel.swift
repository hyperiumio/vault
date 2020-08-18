import Combine
import Pasteboard
import Store

protocol PasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    
    func copyPasswordToPasteboard()
    
}

class PasswordModel: PasswordModelRepresentable {
    
    @Published var password: String
    
    var passwordItem: PasswordItem {
        PasswordItem(password: password)
    }
    
    init(_ passwordItem: PasswordItem) {
        self.password = passwordItem.password
    }
    
    init() {
        self.password = ""
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password
    }
    
}
