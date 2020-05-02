import CryptoKit
import Foundation

func VaultItemEncrypt(_ vaultItem: VaultItem, key: SymmetricKey) throws -> Data {
    let encodedVaultItemInfo = try VaultItemInfoEncode(vaultItem.info)
    let encodedSecureItems = try vaultItem.secureItems.map { vaultItem in
        return try SecureItemEncode(vaultItem)
    }
    let messages = [encodedVaultItemInfo] + encodedSecureItems
    
    return try SecureData.encode(messages: messages, using: key)
}

func VaultItemDecryptInfo(from context: ByteBufferContext, key: SymmetricKey) throws -> VaultItem.Info {
    let secureData = try SecureData(using: key, from: context)
    let encodedVaultItemInfo = try secureData.plaintext(at: .infoIndex, from: context)
    return try VaultItemInfoDecode(data: encodedVaultItemInfo)
}

func VaultItemDecrypt(from context: ByteBufferContext, key: SymmetricKey) throws -> VaultItem {
    let secureData = try SecureData(using: key, from: context)
    
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

private extension Int {
    
    static let infoIndex = 0
    static let secureItemIndex = 1
    static let secondarySecureItemOffset = 2
    
}
