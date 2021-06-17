import Combine
import Crypto
import Foundation
import Pasteboard
import Model

@MainActor
protocol WifiStateRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var password: String { get set }
    var item: WifiItem { get }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) async
    
}

@MainActor
class WifiState: WifiStateRepresentable {
    
    @Published var name: String
    @Published var password: String
    
    private let operationQueue = DispatchQueue(label: "WifiStateOperationQueue")
    
    var item: WifiItem {
        let name = self.name.isEmpty ? nil : self.name
        let password = self.password.isEmpty ? nil : self.password
        
        return WifiItem(name: name, password: password)
    }
    
    init(_ item: WifiItem) {
        self.name = item.name ?? ""
        self.password = item.password ?? ""
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) async {
    }
    
}

#if DEBUG
class WifiStateStub: WifiStateRepresentable {
    
    @Published var name = ""
    @Published var password = ""
    
    var item: WifiItem {
        WifiItem(name: name, password: password)
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) {}
    
}
#endif
