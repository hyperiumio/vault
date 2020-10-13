import Foundation

public struct VaultContainer<Key, Header, Message> where Key: KeyRepresentable, Header: HeaderRepresentable, Message: MessageRepresentable, Key == Header.Key, Key == Message.Key {
    
    let vaultID: UUID
    let resourceLocator: VaultResourceLocator
    let keyContainer: Data
    let elements: [Element]
    
    public func unlock(with password: String) throws -> Vault {
        let masterKey = try Key(from: keyContainer, using: password)
        
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
        
        return Vault(id: vaultID, masterKey: masterKey, resourceLocator: resourceLocator, initialElements: indexElements)
    }
    
}

extension VaultContainer {
    
    public typealias Vault = Store.Vault<Key, Header, Message>
    
    struct Element {
        
        let url: URL
        let header: Header
        let message: Message
        
    }
    
}
