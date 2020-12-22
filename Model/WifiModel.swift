import Combine
import Crypto
import Foundation
import Pasteboard
import Storage

protocol WifiModelRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var password: String { get set }
    var item: WifiItem { get }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool)
    
}

class WifiModel: WifiModelRepresentable {
    
    @Published var name: String
    @Published var password: String
    
    private let operationQueue = DispatchQueue(label: "WifiModelOperationQueue")
    
    var item: WifiItem {
        let name = self.name.isEmpty ? nil : self.name
        let password = self.password.isEmpty ? nil : self.password
        
        return WifiItem(name: name, password: password)
    }
    
    init(_ item: WifiItem) {
        self.name = item.name ?? ""
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
class WifiModelStub: WifiModelRepresentable {
    
    @Published var name = ""
    @Published var password = ""
    
    var item: WifiItem {
        WifiItem(name: name, password: password)
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) {}
    
}
#endif
