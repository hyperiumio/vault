import CryptoKit
import Foundation

struct VaultItemCryptor {
    
    let masterKey: SymmetricKey
    
    func encode(_ vaultItem: VaultItem) throws -> Data {
        let encodedVaultItemInfo = try VaultItemInfoEncode(vaultItem.info)
        let encodedSecureItems = try vaultItem.secureItems.map { vaultItem in
            return try SecureItemEncode(vaultItem)
        }
        let messages = [encodedVaultItemInfo] + encodedSecureItems
        
        return try SecureData.encode(messages: messages, using: masterKey)
    }
    
    func decodeInfo(from context: ByteBufferContext) throws -> VaultItem.Info {
        let secureData = try SecureData(using: masterKey, from: context)
        let encodedVaultItemInfo = try secureData.plaintext(at: .infoIndex, from: context)
        return try VaultItemInfoDecode(data: encodedVaultItemInfo)
    }
    
}

private extension Int {
    
    static let infoIndex = 0
    
}
