import Foundation

public struct VaultItemToken<Cryptor> where Cryptor: MultiMessageCryptor {
    
    public var id: UUID { itemInfo.id }
    public var title: String { itemInfo.title }
    public var typeIdentifier: SecureItem.TypeIdentifier { itemInfo.primaryTypeIdentifier }
    
    private let itemInfo: VaultItem.Info
    private let cryptor: VaultItemCryptor<Cryptor>
    
    init(cryptoKey: Cryptor.Key, from reader: FileReader) throws {
        let cryptor = try VaultItemCryptor<Cryptor>(using: cryptoKey, from: reader)
        let itemInfo = try cryptor.decryptedItemInfo(using: cryptoKey, from: reader)
        
        self.itemInfo = itemInfo
        self.cryptor = cryptor
    }
    
    func decryptedVaultItem(using key: Cryptor.Key, from reader: FileReader) throws -> VaultItem {
        return try cryptor.decryptedVaultItem(for: itemInfo, using: key, from: reader)
    }
    
}
