import Foundation

public protocol MessageRepresentable {
    
    associatedtype CryptoKey
    
    init(nonce: Data, ciphertext: Data, tag: Data)
    
    func decrypt(using itemKey: CryptoKey) throws -> Data
    
    static func encryptContainer(from messages: [Data], using masterKey: CryptoKey) throws -> Data
    static func decryptMessages(from container: Data, using masterKey: CryptoKey) throws -> [Data]
    
}
