import Foundation

public struct LockedVault<Key, Header, Message> where Key: KeyRepresentable, Header: HeaderRepresentable, Message: MessageRepresentable, Key == Header.Key, Key == Message.Key {
    
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
                return VaultIndex.Element(url: element.url, header: element.header, info: vaultItemInfo)
            } catch {
                return nil
            }
        } as [VaultIndex.Element]
        
        let index = VaultIndex(indexElements)
        
        return Vault(id: vaultID, masterKey: masterKey, resourceLocator: resourceLocator, initialIndex: index)
    }
    
}

extension LockedVault {
    
    public typealias Vault = Store.Vault<Key, Header, Message>
    typealias  VaultIndex = Store.VaultIndex<Header>
    
    struct Element {
        
        let url: URL
        let header: Header
        let message: Message
        
    }
    
}
