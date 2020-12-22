import Foundation

public struct StoreResourceLocator {
    
    let rootDirectory: URL
    
    init(_ rootDirectory: URL) {
        self.rootDirectory = rootDirectory
    }
    
    var container: URL {
        rootDirectory.deletingLastPathComponent()
    }
    
    var key: URL {
        rootDirectory.appendingPathComponent("Key", isDirectory: false)
    }
    
    var info: URL {
        rootDirectory.appendingPathComponent("Info", isDirectory: false).appendingPathExtension(for: .json)
    }
    
    var items: URL {
        rootDirectory.appendingPathComponent("Items", isDirectory: true)
    }
    
    func item() -> URL {
        let fileName = UUID().uuidString
        return items.appendingPathComponent(fileName, isDirectory: false)
    }
    
}
