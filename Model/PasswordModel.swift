import Combine
import Crypto
import Foundation
import Pasteboard
import Storage

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
            try PasswordGenerator(length: length, uppercase: true, lowercase: true, digit: digitsEnabled, symbol: symbolsEnabled)
        }
        .replaceError(with: "")
        .receive(on: DispatchQueue.main)
        .assign(to: &$password)
    }
    
}

private extension DispatchQueue {
    
    func future<Success>(catching body: @escaping () throws -> Success) -> Future<Success, Error> {
        Future { promise in
            self.async {
                let result = Result(catching: body)
                promise(result)
            }
        }
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
