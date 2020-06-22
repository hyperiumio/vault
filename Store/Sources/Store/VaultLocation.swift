import Foundation

public struct VaultLocation {
    
    public let rootDirectory: URL
    private let vaultId: UUID
    
    init(in rootDirectory: URL) throws {
        guard rootDirectory.hasDirectoryPath else {
            throw VaultLocationError.invalidUrl
        }
        
        self.rootDirectory = rootDirectory
        self.vaultId = UUID()
    }
    
    init(from vaultDirectory: URL) throws {
        let rootDirectoryUrl = vaultDirectory.deletingLastPathComponent()
        
        guard rootDirectoryUrl.hasDirectoryPath else {
            throw VaultLocationError.invalidUrl
        }
        guard let vaultId = UUID(uuidString: vaultDirectory.lastPathComponent) else {
            throw VaultLocationError.invalidUrl
        }
        
        self.rootDirectory = rootDirectoryUrl
        self.vaultId = vaultId
    }
    
    public var vaultDirectory: URL {
        return rootDirectory.appendingPathComponent(vaultId.uuidString, isDirectory: true)
    }
    
    public var info: URL {
        return vaultDirectory.appendingPathComponent("info.json", isDirectory: false)
    }
    
    public var key: URL {
        return vaultDirectory.appendingPathComponent("key", isDirectory: false)
    }
    
    public var itemDirectory: URL {
        return vaultDirectory.appendingPathComponent("item", isDirectory: true)
    }
    
    public func item(matching id: UUID) -> URL {
        return itemDirectory.appendingPathComponent(id.uuidString, isDirectory: false)
    }
}

enum VaultLocationError: Error {
    
    case invalidUrl
    
}
