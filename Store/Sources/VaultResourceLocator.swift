import Foundation

public struct VaultResourceLocator {
    
    let rootDirectory: URL
    
    init(_ rootDirectory: URL) {
        self.rootDirectory = rootDirectory
    }
    
    var container: URL {
        rootDirectory.deletingLastPathComponent()
    }
    
    var derivedKeyContainer: URL {
        rootDirectory.appendingPathComponent("DerivedKeyContainer", isDirectory: false)
    }
    
    var masterKeyContainer: URL {
        rootDirectory.appendingPathComponent("MasterKeyContainer", isDirectory: false)
    }
    
    var info: URL {
        rootDirectory.appendingPathComponent("Info", isDirectory: false)
    }
    
    var items: URL {
        rootDirectory.appendingPathComponent("Items", isDirectory: true)
    }
    
    func item() -> URL {
        let fileName = UUID().uuidString
        return items.appendingPathComponent(fileName, isDirectory: false)
    }
    
}
