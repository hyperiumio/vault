import Foundation

public struct VaultContainer<CryptoKey, Header, Message> where CryptoKey: CryptoKeyRepresentable, Header: HeaderRepresentable, Message: MessageRepresentable, Header.CryptoKey == CryptoKey, Message.CryptoKey == CryptoKey {
    
    let vaultID: UUID
    let resourceLocator: VaultResourceLocator
    let derivedKeyContainer: Data
    let masterKeyContainer: Data
    let elements: [Element]
    
    public func unlockVault(with password: String) throws -> Vault {
        let derivedKey = try CryptoKey(fromDerivedKeyContainer: derivedKeyContainer, password: password)
        return try unlockVault(with: derivedKey)
        
    }
    
    public func unlockVault(with derivedKey: CryptoKey) throws -> Vault {
        let masterKey = try CryptoKey(fromEncryptedKeyContainer: masterKeyContainer, using: derivedKey)
        
        let indexElements = elements.compactMap { element in
            do {
                let itemKey = try element.header.unwrapKey(with: masterKey)
                let vaultItemInfoData = try element.message.decrypt(using: itemKey)
                let vaultItemInfo = try VaultItemInfo(from: vaultItemInfoData)
                return Vault.Element(url: element.url, header: element.header, info: vaultItemInfo)
            } catch {
                return nil
            }
        } as [Vault.Element]
        
        return Vault(id: vaultID, derivedKey: derivedKey, masterKey: masterKey, resourceLocator: resourceLocator, initialElements: indexElements)
    }
    
    public func decryptSecureItems<T>(for itemType: T.Type, with password: String) throws -> [VaultItemInfo: [T]] where T: SecureItemValue {
        let derivedKey = try CryptoKey(fromDerivedKeyContainer: derivedKeyContainer, password: password)
        return try decryptSecureItems(for: itemType, with: derivedKey)
    }
    
    public func decryptSecureItems<T>(for itemType: T.Type, with derivedKey: CryptoKey) throws -> [VaultItemInfo: [T]] where T: SecureItemValue {
        let masterKey = try CryptoKey(fromEncryptedKeyContainer: masterKeyContainer, using: derivedKey)
        
        var result = [VaultItemInfo: [T]]()
        for element in elements {
            do {
                let itemKey = try element.header.unwrapKey(with: masterKey)
                let vaultItemInfoData = try element.message.decrypt(using: itemKey)
                let vaultItemInfo = try VaultItemInfo(from: vaultItemInfoData)
                let itemTypes = [vaultItemInfo.primaryType] + vaultItemInfo.secondaryTypes
                let data = try Data(contentsOf: element.url)
                
                for (index, currentItemType) in itemTypes.enumerated() {
                    guard currentItemType == itemType.secureItemType else { continue }
                    
                    let index = index + 1
                    let nonceRange = element.header.elements[index].nonceRange
                    let ciphertextRange = element.header.elements[index].ciphertextRange
                    
                    let nonce = data[nonceRange]
                    let ciphertext = data[ciphertextRange]
                    let tag = element.header.elements[index].tag
                    let itemData = try Message(nonce: nonce, ciphertext: ciphertext, tag: tag).decrypt(using: itemKey)
                    let item = try T(from: itemData)
                    
                    if result[vaultItemInfo] == nil {
                        result[vaultItemInfo] = []
                    }
                    
                    result[vaultItemInfo]?.append(item)
                }
            } catch {
                continue
            }
        }
        
        return result
    }
    
}

extension VaultContainer {
    
    public typealias Vault = Store.Vault<CryptoKey, Header, Message>
    
    struct Element {
        
        let url: URL
        let header: Header
        let message: Message
        
    }
    
}
