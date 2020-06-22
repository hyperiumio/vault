import CryptoKit
import Foundation

public struct MasterKey: Equatable {
    
    let cryptoKey: SymmetricKey
    
    public init() {
        self.cryptoKey = SymmetricKey(size: .bits256)
    }
    
    init(_ data: Data) {
        self.cryptoKey = SymmetricKey(data: data)
    }
    
}
