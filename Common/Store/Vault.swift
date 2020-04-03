import CryptoKit
import Foundation

class Vault {
    
    private let url: URL
    private let masterKey: SymmetricKey
    
    init(url: URL, masterKey: SymmetricKey) {
        self.url = url
        self.masterKey = masterKey
    }
    
}
