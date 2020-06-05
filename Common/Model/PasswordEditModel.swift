import Combine
import Store

class PasswordEditModel: ObservableObject, Identifiable {
    
    @Published var password: String
    
    var isComplete: Bool { !password.isEmpty }
    
    var secureItem: SecureItem? {
        guard !password.isEmpty else {
            return nil
        }
        
        let password = Password(value: self.password)
        return SecureItem.password(password)
    }
    
    init(_ password: Password? = nil) {
        self.password = password?.value ?? ""
    }
    
}
