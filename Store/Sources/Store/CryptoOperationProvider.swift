import Foundation

public protocol CryptoOperationProvider {
    
    init()
    init(from encryptedKeyContainer: Data, with password: String) throws
    
    func encrypted(_ messages: [Data]) throws -> Data
    func ciphertextContainer(at index: Int, from fileReader: FileReader) throws -> CiphertextContainerRepresentable
    func decrypted(_ ciphertextContainer: CiphertextContainerRepresentable) throws -> Data
    func decrypted(messageAt index: Int, from fileReader: FileReader) throws -> Data
    func encryptedKeyContainer(with password: String) throws -> Data
    func keyIsEqualToKey(from masterKeyContainer: Data, using password: String) -> Bool
    
}

public protocol CiphertextContainerRepresentable {
    
    func decrypted() throws -> Data
    
}
