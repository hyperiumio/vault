import CryptoKit
import Foundation

struct VaultItemContainer {
    
    let secureData: SecureData
    let info: Info
    
    init(using masterKey: SymmetricKey, from context: ByteBufferContext) throws {
        let infoIndex = 0
        let secureData = try SecureData(using: masterKey, from: context)
        let info = try secureData.plaintext(at: infoIndex, from: context).transform { data in
            return try JSONDecoder().decode(Info.self, from: data)
        }
        
        self.secureData = secureData
        self.info = info
    }
    
    func items(from context: ByteBufferContext) throws -> [VaultItem] {
        return try info.itemTypes.enumerated().map { index, itemType in
            return try secureData.plaintext(at: index, from: context).transform { data in
                return try VaultItemDecode(data: data, as: itemType)
            }
        }
    }
    
}

extension VaultItemContainer {
    
    static func encode(items: [VaultItem], using masterKey: SymmetricKey) throws -> Data {
        let itemTypes = items.map(\.itemType)
        let info = Info(itemTypes: itemTypes)
        
        let encodedInfo = try JSONEncoder().encode(info)
        let encodedItems = try items.map { vaultItem in
            return try VaultItemEncode(vaultItem)
        }
        let messages = [encodedInfo] + encodedItems
        
        return try SecureData.encode(messages: messages, using: masterKey)
    }
    
}

extension VaultItemContainer {
    
    struct Info: Codable {
        
        let id: UUID
        let itemTypes: [VaultItem.ItemType]
        
        init(itemTypes: [VaultItem.ItemType]) {
            self.id = UUID()
            self.itemTypes = itemTypes
        }
    }
    
}
