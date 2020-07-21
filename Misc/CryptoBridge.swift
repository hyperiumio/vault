import Foundation
import Crypto
import Store

extension FileReader: DataContext {}

extension SecureDataCryptor: MultiMessageCryptor {
    
    public init(using key: MasterKey, from reader: FileReader) throws {
        try self.init(using: key, from: reader as DataContext)
    }
    
    public func decryptPlaintext(at index: Int, using key: MasterKey, from reader: FileReader) throws -> Data {
        return try decryptPlaintext(at: index, using: key, from: reader as DataContext)
    }
    
}

extension MasterKey: CryptoKeyRepresentable {
    
    public static func encoded(_ key: MasterKey, using password: String) throws -> Data {
        return try MasterKeyContainerEncode(key, with: password)
    }
    
    public static func decoded(from data: Data, using password: String) throws -> MasterKey {
        return try MasterKeyContainerDecode(data, with: password)
    }
    
    
}
