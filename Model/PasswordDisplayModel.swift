import Combine
import Pasteboard
import Store

protocol PasswordDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get }
    
    func copyPasswordToPasteboard()
    
}

class PasswordDisplayModel: PasswordDisplayModelRepresentable {
    
    var password: String { passwordItem.password }
    
    private let passwordItem: PasswordItem
    
    init(_ passwordItem: PasswordItem) {
        self.passwordItem = passwordItem
    }
    
    func copyPasswordToPasteboard() {
        Pasteboard.general.string = password
    }
    
}
