import Combine
import Store

protocol PasswordEditModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    
}

class PasswordEditModel: PasswordEditModelRepresentable {
    
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
    
}
