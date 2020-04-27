import Combine

class PasswordEditModel: ObservableObject, Identifiable {
    
    @Published var password: String
    
    var isComplete: Bool {
        return !password.isEmpty
    }
    
    var secureItem: SecureItem? {
        guard !password.isEmpty else {
            return nil
        }
        
        return SecureItem.password(password)
    }
    
    init(_ password: String? = nil) {
        self.password = password ?? ""
    }
    
}
