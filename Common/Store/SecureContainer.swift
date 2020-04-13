import CryptoKit
import Foundation

struct SecureContainer {
    
    let secureData: SecureData
    let info: Info
    
    init(using masterKey: SymmetricKey, from context: ByteBufferContext) throws {
        let infoIndex = 0
        let secureData = try SecureData(using: masterKey, from: context)
        let info = try secureData.plaintext(at: infoIndex, from: context).map { data in
            return try JSONDecoder().decode(Info.self, from: data)
        }
        
        self.secureData = secureData
        self.info = info
    }
    
    func items(from context: ByteBufferContext) throws -> [SecureItem] {
        return try info.itemTypes.enumerated().map { index, itemType in
            return try secureData.plaintext(at: index, from: context).map { data in
                return try SecureContainerItemDecode(data: data, as: itemType)
            }
        }
    }
    
}

extension SecureContainer {
    
    static func encode(title: String, items: [SecureItem], using masterKey: SymmetricKey) throws -> Data {
        let itemTypes = items.map(\.itemType)
        let info = Info(title: title, itemTypes: itemTypes)
        
        let encodedInfo = try JSONEncoder().encode(info)
        let encodedItems = try items.map { vaultItem in
            return try SecureContainerItemEncode(vaultItem)
        }
        let messages = [encodedInfo] + encodedItems
        
        return try SecureData.encode(messages: messages, using: masterKey)
    }
    
}

extension SecureContainer {
    
    struct Info: Codable, Identifiable {
        
        let id: UUID
        let title: String
        let itemTypes: [SecureItemType]
        
        init(title: String, itemTypes: [SecureItemType]) {
            self.id = UUID()
            self.title = title
            self.itemTypes = itemTypes
        }
    }
    
}
