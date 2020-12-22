import Combine
import Crypto
import Foundation
import Pasteboard
import Storage

protocol LoginModelRepresentable: ObservableObject, Identifiable {

    var username: String { get set }
    var password: String { get set }
    var url: String { get set}
    var item: LoginItem { get }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool)
    
}

class LoginModel: LoginModelRepresentable {
    
    @Published var username: String
    @Published var password: String
    @Published var url: String
    
    private let operationQueue = DispatchQueue(label: "LoginModelOperationQueue")
    
    var item: LoginItem {
        let username = self.username.isEmpty ? nil : self.username
        let password = self.password.isEmpty ? nil : self.password
        let url = self.url.isEmpty ? nil : self.url
        
        return LoginItem(username: username, password: password, url: url)
    }
    
    init(_ item: LoginItem) {
        self.username = item.username ?? ""
        self.password = item.password ?? ""
        self.url = item.url ?? ""
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
class LoginModelStub: LoginModelRepresentable {
    
    @Published var username = ""
    @Published var password = ""
    @Published var url = ""
    
    var item: LoginItem {
        LoginItem(username: username, password: password, url: url)
    }

    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) {}
    
}
#endif
