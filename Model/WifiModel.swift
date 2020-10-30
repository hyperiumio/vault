import Combine
import Crypto
import Foundation
import Pasteboard
import Store

protocol WifiModelRepresentable: ObservableObject, Identifiable {
    
    var networkPassword: String { get set }
    var networkName: String { get set }
    var wifiItem: WifiItem { get }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool)
    
}

class WifiModel: WifiModelRepresentable {
    
    @Published var networkPassword: String
    @Published var networkName: String
    
    private let operationQueue = DispatchQueue(label: "WifiModelOperationQueue")
    
    var wifiItem: WifiItem {
        let networkName = self.networkName.isEmpty ? nil : self.networkName
        let networkPassword = self.networkPassword.isEmpty ? nil : self.networkPassword
        
        return WifiItem(networkName: networkName, networkPassword: networkPassword)
    }
    
    init(_ wifiItem: WifiItem) {
        self.networkName = wifiItem.networkName ?? ""
        self.networkPassword = wifiItem.networkPassword ?? ""
    }
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) {
        operationQueue.future {
            try Password(length: length, uppercase: true, lowercase: true, digit: digitsEnabled, symbol: symbolsEnabled)
        }
        .replaceError(with: "")
        .receive(on: DispatchQueue.main)
        .assign(to: &$networkPassword)
    }
    
}
