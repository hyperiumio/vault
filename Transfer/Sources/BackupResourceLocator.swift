import Foundation

struct BackupResourceLocator {
    
    let root: URL
    
    var masterKeyURL: URL {
        root.appendingPathComponent("MasterKey", isDirectory: true)
    }
    
    var storeURL: URL {
        root.appendingPathComponent("Store", isDirectory: true)
    }
    
}
