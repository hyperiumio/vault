import Combine
import Pasteboard
import Store

class PasswordDisplayModel: ObservableObject, Identifiable {
    
    @Published var secureDisplay = true
    
    var value: String { password.value }
    
    private let password: Password
    
    init(_ password: Password) {
        self.password = password
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password.value
    }
    
}
