import CryptoKit
import Foundation

func VaultItemEncrypt(_ vaultItem: VaultItem, key: SymmetricKey) throws -> Data {
    let encodedVaultItemInfo = try VaultItemInfoEncode(vaultItem.info)
    let encodedSecureItems = try vaultItem.secureItems.map { secureItem in
        return try SecureItemEncode(secureItem)
    }
    let messages = [encodedVaultItemInfo] + encodedSecureItems
    
    return try SecureDataEncrypt(messages: messages, using: key)
}

func VaultItemInfoDecrypt(token: SecureDataDecryptionToken, context: ByteBufferContext) throws -> VaultItem.Info {
    let encodedVaultItemInfo = try SecureDataDecryptPlaintext(token: token, context: context, index: .infoIndex)
    return try VaultItemInfoDecode(data: encodedVaultItemInfo)
}

func VaultItemDecrypt(token: SecureDataDecryptionToken, context: ByteBufferContext) throws -> VaultItem {
    let vaultItemInfo = try VaultItemInfoDecrypt(token: token, context: context)
    
    let secureItem = try SecureDataDecryptPlaintext(token: token, context: context, index: .secureItemIndex).map { data in
        return try SecureItemDecode(data: data, as: vaultItemInfo.itemType)
    }
    
    let secondarySecureItemIndexes = vaultItemInfo.secondaryItemTypes.indices.moved(by: .secondarySecureItemOffset)
    let secondarySecureItems = try zip(secondarySecureItemIndexes, vaultItemInfo.secondaryItemTypes).map { index, type in
        return try SecureDataDecryptPlaintext(token: token, context: context, index: index).map { data in
            return try SecureItemDecode(data: data, as: type)
        }
    }
    
    return VaultItem(id: vaultItemInfo.id, title: vaultItemInfo.title, secureItem: secureItem, secondarySecureItems: secondarySecureItems)
}

private extension Int {
    
    static let infoIndex = 0
    static let secureItemIndex = 1
    static let secondarySecureItemOffset = 2
    
}
