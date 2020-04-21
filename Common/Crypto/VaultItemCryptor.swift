import CryptoKit
import Foundation

struct VaultItemCryptor {
    
    let masterKey: SymmetricKey
    
    func encode(_ vaultItem: VaultItem) throws -> Data {
        let encodedInfo = try VaultItemInfoEncode(vaultItem.info)
        let encodedItems = try vaultItem.secureItems.map { vaultItem in
            return try SecureContainerItemEncode(vaultItem)
        }
        let messages = [encodedInfo] + encodedItems
        
        return try SecureData.encode(messages: messages, using: masterKey)
    }
    
    func decodeInfo(from context: ByteBufferContext) throws -> VaultItem.Info {
        let secureData = try SecureData(using: masterKey, from: context)
        let infoData = try secureData.plaintext(at: .infoIndex, from: context)
        return try VaultItemInfoDecode(data: infoData)
    }
    
}

private extension Int {
    
    static let infoIndex = 0
    
}
