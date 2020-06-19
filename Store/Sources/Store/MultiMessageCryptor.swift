import Foundation

public protocol MultiMessageCryptor {
    
    associatedtype Key: CryptoKeyRepresentable
    
    init(using key: Key, from reader: FileReader) throws
    
    func decryptPlaintext(at index: Int, using key: Key, from reader: FileReader) throws -> Data
    
    static func encrypted(_ messages: [Data], using key: Key) throws -> Data
    
}
