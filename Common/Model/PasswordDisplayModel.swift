import Combine

class PasswordDisplayModel: ObservableObject, Identifiable {
    
    let password: String
    
    init(_ password: Password) {
        self.password = password
    }
    
}
