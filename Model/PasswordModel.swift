import Combine
import Crypto
import Foundation
import Pasteboard
import Store

protocol PasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var passwordItem: PasswordItem { get }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool)
    
}

class PasswordModel: PasswordModelRepresentable {
    
    @Published var password: String
    
    private let operationQueue = DispatchQueue(label: "PasswordModelOperationQueue")
    
    var passwordItem: PasswordItem {
        PasswordItem(password: password)
    }
    
    init(_ passwordItem: PasswordItem) {
        self.password = passwordItem.password
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) {
        operationQueue.future {
            try Password(length: length, uppercase: true, lowercase: true, digit: digitsEnabled, symbol: symbolsEnabled)
        }
        .replaceError(with: "")
        .receive(on: DispatchQueue.main)
        .assign(to: &$password)
    }
    
}
