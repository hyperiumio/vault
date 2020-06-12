import Combine
import Store

class PasswordEditModel: ObservableObject, Identifiable {
    
    @Published var password: String
    
    var isComplete: Bool { !password.isEmpty }
    
    var secureItem: SecureItem? {
        guard !password.isEmpty else {
            return nil
        }
        
        let password = PasswordItem(password: self.password)
        return SecureItem.password(password)
    }
    
    init(_ passwordItem: PasswordItem? = nil) {
        self.password = passwordItem?.password ?? ""
    }
    
}
