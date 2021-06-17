import Combine
import Crypto
import Foundation
import Pasteboard
import Persistence

@MainActor
protocol PasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var item: PasswordItem { get }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) async
    
}

@MainActor
class PasswordModel: PasswordModelRepresentable {
    
    @Published var password: String
    
    var item: PasswordItem {
        let password = self.password.isEmpty ? nil : self.password
        
        return PasswordItem(password: password)
    }
    
    init(_ item: PasswordItem) {
        self.password = item.password ?? ""
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) async {
    }
    
}

#if DEBUG
class PasswordModelStub: PasswordModelRepresentable {
    
    @Published var password = ""
    
    var item: PasswordItem {
        PasswordItem(password: password)
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) async {}
    
}
#endif
