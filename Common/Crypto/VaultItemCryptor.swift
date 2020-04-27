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
    
    func decodeVaultItem(from context: ByteBufferContext) throws -> VaultItem {
        let secureData = try SecureData(using: masterKey, from: context)
        
        let encodedVaultItemInfo = try secureData.plaintext(at: .infoIndex, from: context)
        let vaultItemInfo = try VaultItemInfoDecode(data: encodedVaultItemInfo)
        
        let encodedSecureItem = try secureData.plaintext(at: .secureItemIndex, from: context)
        let secureItem = try SecureItemDecode(data: encodedSecureItem, as: vaultItemInfo.itemType)
        
        let secondarySecureItems = try vaultItemInfo.secondaryItemTypes.enumerated().map { index, type in
            let secureItemIndex = index + .secondarySecureItemOffset
            let encodedSecureItem = try secureData.plaintext(at: secureItemIndex, from: context)
            return try SecureItemDecode(data: encodedSecureItem, as: type)
        } as [SecureItem]
        
        return VaultItem(id: vaultItemInfo.id, title: vaultItemInfo.title, secureItem: secureItem, secondarySecureItems: secondarySecureItems)
    }
    
}

private extension Int {
    
    static let infoIndex = 0
    static let secureItemIndex = 1
    static let secondarySecureItemOffset = 2
    
}
