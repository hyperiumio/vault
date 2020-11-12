import CryptoKit
import Foundation

public struct MasterKey {
    
    let value: SymmetricKey
    
    public init() {
        self.value = SymmetricKey(size: .bits256)
    }
    
    public init(from data: Data, using derivedKey: DerivedKey) throws {
        let wrappedKey = try AES.GCM.SealedBox(combined: data)
        let masterKeyData = try AES.GCM.open(wrappedKey, using: derivedKey.value)
        
        self.value = SymmetricKey(data: masterKeyData)
    }
    
    init(_ data: Data) {
        self.value = SymmetricKey(data: data)
    }
    
    public func encrypted(using derivedKey: DerivedKey) throws -> Data {
        try value.withUnsafeBytes { cryptoKey in
            let seal = try AES.GCM.seal(cryptoKey, using: derivedKey.value)
            return seal.nonce + seal.ciphertext + seal.tag
        }
    }
    
}
