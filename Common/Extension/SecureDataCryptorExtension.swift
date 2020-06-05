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
