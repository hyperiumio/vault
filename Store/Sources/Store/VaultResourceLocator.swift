import Foundation

struct VaultResourceLocator {
    
    let vaultDirectory: URL
    
    var keyFile: URL {
        vaultDirectory.appendingPathComponent("key", isDirectory: false)
    }
    
    var infoFile: URL {
        vaultDirectory.appendingPathComponent("info", isDirectory: false)
    }
    
    var itemsDirectory: URL {
        vaultDirectory.appendingPathComponent("items", isDirectory: true)
    }
    
    func itemFile(for itemID: UUID) -> URL {
        itemsDirectory.appendingPathComponent(itemID.uuidString, isDirectory: false)
    }
    
    init(_ vaultDirectory: URL) {
        self.vaultDirectory = vaultDirectory
    }
    
}
