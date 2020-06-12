import Combine
import Pasteboard
import Store

class PasswordDisplayModel: ObservableObject, Identifiable {
    
    @Published var secureDisplay = true
    
    var value: String { password.password }
    
    private let password: PasswordItem
    
    init(_ password: PasswordItem) {
        self.password = password
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password.password
    }
    
}
