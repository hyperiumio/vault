import Foundation

public struct BackupResourceLocator {
    
    let root: URL
    
    public var masterKeyURL: URL {
        root.appendingPathComponent("MasterKey", isDirectory: true)
    }
    
    public var storeURL: URL {
        root.appendingPathComponent("Store", isDirectory: true)
    }
    
}
