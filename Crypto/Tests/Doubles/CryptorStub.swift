import CryptoKit
import Foundation
@testable import Crypto

struct CryptorStub: SecureDataMessageCryptor {
    
    let encryptionResult: AES.GCM.SealedBox?
    let authenticationEncryptionResult: AES.GCM.SealedBox?
    
    func encrypt<Plaintext>(_ message: Plaintext, using key: SymmetricKey) throws -> AES.GCM.SealedBox where Plaintext : DataProtocol {
        guard let result = encryptionResult else {
            throw NSError()
        }
        
        return result
    }
    
    func encrypt<Plaintext, AuthenticatedData>(_ message: Plaintext, using key: SymmetricKey, authenticating authenticatedData: AuthenticatedData) throws -> AES.GCM.SealedBox where Plaintext : DataProtocol, AuthenticatedData : DataProtocol {
        guard let result = authenticationEncryptionResult else {
            throw NSError()
        }
        
        return result
    }
    
}
