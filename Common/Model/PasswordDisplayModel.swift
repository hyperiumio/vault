import Combine

class PasswordDisplayModel: ObservableObject, Identifiable {
    
    @Published var secureDisplay = true
    
    let password: String
    
    init(_ password: Password) {
        self.password = password
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password
    }
    
}
