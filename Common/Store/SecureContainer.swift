import CryptoKit
import Foundation

struct SecureContainer {
    
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
    
    func items(from context: ByteBufferContext) throws -> [Item] {
        return try info.itemTypes.enumerated().map { index, itemType in
            return try secureData.plaintext(at: index, from: context).transform { data in
                return try SecureContainerItemDecode(data: data, as: itemType)
            }
        }
    }
    
}

extension SecureContainer {
    
    static func encode(title: String, items: [Item], using masterKey: SymmetricKey) throws -> Data {
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
        let itemTypes: [ItemType]
        
        init(title: String, itemTypes: [ItemType]) {
            self.id = UUID()
            self.title = title
            self.itemTypes = itemTypes
        }
    }
    
    enum Item {
        
        case password(Password)
        case login(Login)
        case file(File)
        
        var itemType: ItemType {
            switch self {
            case .password:
                return .password
            case .login:
                return .login
            case .file:
                return .file
            }
        }
        
    }

    enum ItemType: String, Codable {
        
        case password
        case login
        case file
        
    }
    
}
