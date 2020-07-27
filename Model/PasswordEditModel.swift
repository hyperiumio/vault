import Combine
import Store

class PasswordEditModel: ObservableObject, Identifiable {
    
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
