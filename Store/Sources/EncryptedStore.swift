import Foundation

public struct EncryptedStore<CryptoKey, Header, Message> where CryptoKey: CryptoKeyRepresentable, Header: HeaderRepresentable, Message: MessageRepresentable, Header.CryptoKey == CryptoKey, Message.CryptoKey == CryptoKey {
    
    let storeID: UUID
    let resourceLocator: StoreResourceLocator
    let derivedKeyContainer: Data
    let masterKeyContainer: Data
    let elements: [Element]
    
    public func unlock(with password: String) throws -> Store {
        let derivedKey = try CryptoKey(fromDerivedKeyContainer: derivedKeyContainer, password: password)
        return try unlock(with: derivedKey)
        
    }
    
    public func unlock(with derivedKey: CryptoKey) throws -> Store {
        let masterKey = try CryptoKey(fromEncryptedKeyContainer: masterKeyContainer, using: derivedKey)
        
        let initialElements = elements.compactMap { element in
            do {
                let itemKey = try element.header.unwrapKey(with: masterKey)
                let infoData = try element.message.decrypt(using: itemKey)
                let info = try SecureContainerInfo(from: infoData)
                return Store.Element(url: element.url, header: element.header, info: info)
            } catch {
                return nil
            }
        } as [Store.Element]
        
        return Store(id: storeID, derivedKey: derivedKey, masterKey: masterKey, resourceLocator: resourceLocator, initialElements: initialElements)
    }
    
    public func decryptSecureItems<Item>(for itemType: Item.Type, with password: String) throws -> [SecureContainerInfo: [Item]] where Item: SecureItemValue {
        let derivedKey = try CryptoKey(fromDerivedKeyContainer: derivedKeyContainer, password: password)
        return try decryptSecureItems(for: itemType, with: derivedKey)
    }
    
    public func decryptSecureItems<Item>(for itemType: Item.Type, with derivedKey: CryptoKey) throws -> [SecureContainerInfo: [Item]] where Item: SecureItemValue {
        let masterKey = try CryptoKey(fromEncryptedKeyContainer: masterKeyContainer, using: derivedKey)
        
        var result = [SecureContainerInfo: [Item]]()
        for element in elements {
            do {
                let itemKey = try element.header.unwrapKey(with: masterKey)
                let infoData = try element.message.decrypt(using: itemKey)
                let info = try SecureContainerInfo(from: infoData)
                let types = [info.primaryType] + info.secondaryTypes
                let data = try Data(contentsOf: element.url)
                
                for (index, type) in types.enumerated() {
                    guard type == itemType.secureItemType else { continue }
                    
                    let index = index + 1
                    let nonceRange = element.header.elements[index].nonceRange
                    let ciphertextRange = element.header.elements[index].ciphertextRange
                    
                    let nonce = data[nonceRange]
                    let ciphertext = data[ciphertextRange]
                    let tag = element.header.elements[index].tag
                    let itemData = try Message(nonce: nonce, ciphertext: ciphertext, tag: tag).decrypt(using: itemKey)
                    let item = try Item(from: itemData)
                    
                    if result[info] == nil {
                        result[info] = []
                    }
                    
                    result[info]?.append(item)
                }
            } catch {
                continue
            }
        }
        
        return result
    }
    
}

extension EncryptedStore {
    
    public typealias Store = Storage.Store<CryptoKey, Header, Message>
    
    struct Element {
        
        let url: URL
        let header: Header
        let message: Message
        
    }
    
}
