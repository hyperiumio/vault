import Foundation

public protocol MessageRepresentable {
    
    associatedtype MasterKey
    associatedtype MessageKey
    
    init(nonce: Data, ciphertext: Data, tag: Data)
    
    func decrypt(using itemKey: MessageKey) throws -> Data
    
    static func encryptContainer(from messages: [Data], using masterKey: MasterKey) throws -> Data
    static func decryptMessages(from container: Data, using masterKey: MasterKey) throws -> [Data]
    
}
