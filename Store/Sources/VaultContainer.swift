import Foundation

public struct VaultContainer<DerivedKey, MasterKey, MessageKey, Header, Message> where DerivedKey: DerivedKeyRepresentable, MasterKey: MasterKeyRepresentable, Header: HeaderRepresentable, Message: MessageRepresentable, DerivedKey == MasterKey.DerivedKey, MasterKey == Header.MasterKey, MasterKey == Message.MasterKey, MessageKey == Header.MessageKey, MessageKey == Message.MessageKey {
    
    let vaultID: UUID
    let resourceLocator: VaultResourceLocator
    let derivedKeyContainer: Data
    let masterKeyContainer: Data
    let elements: [Element]
    
    public func unlock(with password: String) throws -> Vault {
        let derivedKey = try DerivedKey(container: derivedKeyContainer, password: password)
        return try unlock(with: derivedKey)
        
    }
    
    public func unlock(with derivedKey: DerivedKey) throws -> Vault {
        let masterKey = try MasterKey(from: masterKeyContainer, using: derivedKey)
        
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
    
}

extension VaultContainer {
    
    public typealias Vault = Store.Vault<DerivedKey, MasterKey, MessageKey, Header, Message>
    
    struct Element {
        
        let url: URL
        let header: Header
        let message: Message
        
    }
    
}
