import Combine
import Store

class PasswordEditModel: ObservableObject, Identifiable {
    
    @Published var password: String
    
    var isComplete: Bool { !password.isEmpty }
    
    var secureItem: SecureItem? {
        guard isComplete else { return nil }
        
        let password = PasswordItem(password: self.password)
        return SecureItem.password(password)
    }
    
    init(_ passwordItem: PasswordItem) {
        self.password = passwordItem.password
    }
    
    init() {
        self.password = ""
    }
    
}
