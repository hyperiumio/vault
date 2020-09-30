import Combine
import Crypto
import Foundation
import Pasteboard
import Store

protocol LoginModelRepresentable: ObservableObject, Identifiable {

    var username: String { get set }
    var password: String { get set }
    var url: String { get set}
    var loginItem: LoginItem { get }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool)
    
}

class LoginModel: LoginModelRepresentable {
    
    @Published var username: String
    @Published var password: String
    @Published var url: String
    
    private let operationQueue = DispatchQueue(label: "LoginModelOperationQueue")
    
    var loginItem: LoginItem {
        LoginItem(username: username, password: password, url: url)
    }
    
    init(_ loginItem: LoginItem) {
        self.username = loginItem.username
        self.password = loginItem.password
        self.url = loginItem.url
    }
    
    init() {
        self.username = ""
        self.password = ""
        self.url = ""
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
