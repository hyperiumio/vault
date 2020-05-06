import Crypto
import Foundation

func VaultItemEncrypt(_ vaultItem: VaultItem, key: MasterKey) throws -> Data {
    let encodedVaultItemInfo = try VaultItemInfoEncode(vaultItem.info)
    let encodedSecureItems = try vaultItem.secureItems.map { secureItem in
        return try SecureItemEncode(secureItem)
    }
    let messages = [encodedVaultItemInfo] + encodedSecureItems
    
    return try SecureDataEncrypt(messages, with: key)
}

func VaultItemInfoDecrypt(token: SecureDataDecryptionToken, context: DataContext) throws -> VaultItem.Info {
    let encodedVaultItemInfo = try SecureDataDecryptPlaintext(at: .infoIndex, using: token, from: context)
    return try VaultItemInfoDecode(data: encodedVaultItemInfo)
}

func VaultItemDecrypt(token: SecureDataDecryptionToken, context: DataContext) throws -> VaultItem {
    let vaultItemInfo = try VaultItemInfoDecrypt(token: token, context: context)
    
    let secureItem = try SecureDataDecryptPlaintext(at: .secureItemIndex, using: token, from: context).map { data in
        return try SecureItemDecode(data: data, as: vaultItemInfo.itemType)
    }
    
    let secondarySecureItemIndexes = vaultItemInfo.secondaryItemTypes.indices.moved(by: .secondarySecureItemOffset)
    let secondarySecureItems = try zip(secondarySecureItemIndexes, vaultItemInfo.secondaryItemTypes).map { index, type in
        return try SecureDataDecryptPlaintext(at: index, using: token, from: context).map { data in
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
