import Foundation

public protocol MessageRepresentable {
    
    associatedtype Key
    
    init(nonce: Data, ciphertext: Data, tag: Data)
    
    func decrypt(using itemKey: Key) throws -> Data
    
    static func encryptContainer(from messages: [Data], using masterKey: Key) throws -> Data
    
}
