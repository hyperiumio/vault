import Combine
import Crypto
import Foundation
import Pasteboard
import Store

protocol PasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var item: PasswordItem { get }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool)
    
}

class PasswordModel: PasswordModelRepresentable {
    
    @Published var password: String
    
    private let operationQueue = DispatchQueue(label: "PasswordModelOperationQueue")
    
    var item: PasswordItem {
        let password = self.password.isEmpty ? nil : self.password
        
        return PasswordItem(password: password)
    }
    
    init(_ item: PasswordItem) {
        self.password = item.password ?? ""
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

#if DEBUG
class PasswordModelStub: PasswordModelRepresentable {
    
    @Published var password = ""
    
    var item: PasswordItem {
        PasswordItem(password: password)
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) {}
    
}
#endif
