import CryptoKit
import Foundation

public struct MasterKey {
    
    let value: SymmetricKey
    
    init<D>(_ data: D) where D: ContiguousBytes {
        self.value = SymmetricKey(data: data)
    }
    
    public init() {
        self.value = SymmetricKey(size: .bits256)
    }
    
    public init(from encryptedContainer: Data, using derivedKey: DerivedKey) throws {
        let encryptedContainer = try AES.GCM.SealedBox(combined: encryptedContainer)
        let masterKeyData = try AES.GCM.open(encryptedContainer, using: derivedKey.value)
        
        self.value = SymmetricKey(data: masterKeyData)
    }
    
    public func encryptedContainer(using derivedKey: DerivedKey) throws -> Data {
        try value.withUnsafeBytes { masterKey in
            guard let encryptedContainer = try? AES.GCM.seal(masterKey, using: derivedKey.value).combined else {
                throw CryptoError.encryptionFailed
            }
            
            return encryptedContainer
        }
    }
    
}
