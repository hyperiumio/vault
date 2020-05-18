import Crypto
import Foundation

struct VaultItemDecodingToken {
    
    fileprivate let version: VaultItemDecodingTokenVersion
    
    init(masterKey: MasterKey, context: DataContext) throws {
        let versionValue = try context.byte(at: .versionIndex)
        let version = try VaultItemVersion(versionValue)
        let decodingTokenContext = context.offset(by: VersionRepresentableByteCount)
        
        switch version {
        case .version1:
            let token = try VaultItemDecodingTokenVersion1(masterKey: masterKey, context: decodingTokenContext)
            self.version = .version1(token)
        }
    }
    
}

func VaultItemEncrypt(_ vaultItem: VaultItem, with masterKey: MasterKey) throws -> Data {
    let version = VaultItemVersion.version1.encoded
    
    let encodedVaultItemInfo = try VaultItemInfoEncode(vaultItem.info)
    let encodedSecureItems = try vaultItem.secureItems.map { secureItem in
        return try SecureItemEncode(secureItem)
    }
    let messages = [encodedVaultItemInfo] + encodedSecureItems
    let secureData = try SecureDataEncrypt(messages, with: masterKey)
    
    return version + secureData
}

func VaultItemInfoDecrypt(token: VaultItemDecodingToken, context: DataContext) throws -> VaultItem.Info {
    let context = context.offset(by: VersionRepresentableByteCount)
    
    switch token.version {
    case .version1(let token):
        return try VaultItemInfoDecryptVersion1(token: token, context: context)
    }
}

func VaultItemDecrypt(token: VaultItemDecodingToken, context: DataContext) throws -> VaultItem {
    let context = context.offset(by: VersionRepresentableByteCount)
    
    switch token.version {
    case .version1(let token):
        return try VaultItemDecryptVersion1(token: token, context: context)
    }
}

private enum VaultItemDecodingTokenVersion {
    
    case version1(VaultItemDecodingTokenVersion1)
    
}

private struct VaultItemDecodingTokenVersion1 {
    
    let decryptionToken: SecureDataDecryptionToken
    
    init(masterKey: MasterKey, context: DataContext) throws {
        self.decryptionToken = try SecureDataDecryptionToken(masterKey: masterKey, context: context)
    }
    
}

private func VaultItemInfoDecryptVersion1(token: VaultItemDecodingTokenVersion1, context: DataContext) throws -> VaultItem.Info {
    let encodedVaultItemInfo = try SecureDataDecryptPlaintext(at: .infoIndex, using: token.decryptionToken, from: context)
    return try VaultItemInfoDecode(data: encodedVaultItemInfo)
}

private func VaultItemDecryptVersion1(token: VaultItemDecodingTokenVersion1, context: DataContext) throws -> VaultItem {
    let vaultItemInfo = try VaultItemInfoDecryptVersion1(token: token, context: context)
    
    let secureItem = try SecureDataDecryptPlaintext(at: .secureItemIndex, using: token.decryptionToken, from: context).map { data in
          return try SecureItemDecode(data: data, as: vaultItemInfo.itemType)
      }
      
      let secondarySecureItemIndexes = vaultItemInfo.secondaryItemTypes.indices.moved(by: .secondarySecureItemOffset)
      let secondarySecureItems = try zip(secondarySecureItemIndexes, vaultItemInfo.secondaryItemTypes).map { index, type in
        return try SecureDataDecryptPlaintext(at: index, using: token.decryptionToken, from: context).map { data in
              return try SecureItemDecode(data: data, as: type)
          }
      }
      
      return VaultItem(id: vaultItemInfo.id, title: vaultItemInfo.title, secureItem: secureItem, secondarySecureItems: secondarySecureItems)
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let secureItemIndex = 1
    static let secondarySecureItemOffset = 2
    
}
