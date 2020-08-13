import Crypto
import Foundation
import Store

struct Cryptor: CryptoOperationProvider {
    
    let masterKey: MasterKey
    
    init() {
        masterKey = MasterKey()
    }
    
    init(from encryptedKeyContainer: Data, with password: String) throws {
        self.masterKey = try MasterKeyContainerDecode(encryptedKeyContainer, with: password)
    }
    
    func encrypted(_ messages: [Data]) throws -> Data {
        try SecureDataCryptor.encrypted(messages, using: masterKey)
    }
    
    func ciphertextContainer(at index: Int, from fileReader: FileReader) throws -> CiphertextContainerRepresentable {
        try SecureDataCryptor(using: masterKey, from: fileReader).ciphertextContainer(at: index, from: fileReader)
    }
    
    func decrypted(_ ciphertextContainer: CiphertextContainerRepresentable) throws -> Data {
        try ciphertextContainer.decrypted()
    }
    
    func decrypted(messageAt index: Int, from fileReader: FileReader) throws -> Data {
        try SecureDataCryptor(using: masterKey, from: fileReader).decryptPlaintext(at: index, using: masterKey, from: fileReader)
    }
    
    func encryptedKeyContainer(with password: String) throws -> Data {
        try MasterKeyContainerEncode(masterKey, with: password)
    }
    
    func keyIsEqualToKey(from masterKeyContainer: Data, using password: String) -> Bool {
        guard let loadedMasterKey = try? MasterKeyContainerDecode(masterKeyContainer, with: password) else {
            return false
        }
        
        return masterKey == loadedMasterKey
    }
    
}

extension FileReader: DataContext {}
extension SecureDataCryptor.CiphertextContainer: CiphertextContainerRepresentable {}
