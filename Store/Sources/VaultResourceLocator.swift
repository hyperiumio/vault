import Foundation

struct VaultResourceLocator {
    
    let rootDirectory: URL
    
    init(_ rootDirectory: URL) {
        self.rootDirectory = rootDirectory
    }
    
    var keyFile: URL {
        rootDirectory.appendingPathComponent("key", isDirectory: false)
    }
    
    var infoFile: URL {
        rootDirectory.appendingPathComponent("info", isDirectory: false)
    }
    
    var itemsDirectory: URL {
        rootDirectory.appendingPathComponent("items", isDirectory: true)
    }
    
    func itemFile() -> URL {
        let fileName = UUID().uuidString
        return itemsDirectory.appendingPathComponent(fileName, isDirectory: false)
    }
    
}
