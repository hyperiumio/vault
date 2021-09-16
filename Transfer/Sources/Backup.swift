import Foundation

public actor Backup {
    
    private let resourceLocator: BackupResourceLocator
    
    public init(url: URL) async throws {
        let resourceLocator = BackupResourceLocator(root: url)
        let containerDirectoryAttributes = [FileAttributeKey.extensionHidden: true]
        try FileManager.default.createDirectory(at: resourceLocator.root, withIntermediateDirectories: true, attributes: containerDirectoryAttributes)
        
        self.resourceLocator = resourceLocator
    }
    
    public func dumpMasterKey(_ masterKey: Data) async throws {
        try masterKey.write(to: resourceLocator.masterKeyURL)
    }
    
    public func dumpStore(copy: @escaping (URL) async throws -> Void) async throws {
        try FileManager.default.createDirectory(at: resourceLocator.storeURL, withIntermediateDirectories: true)
        try await copy(resourceLocator.storeURL)
    }
    
    public func restoreStore(to storeURL: URL) async throws {
        try FileManager.default.copyItem(at: resourceLocator.storeURL, to: storeURL)
    }
    
    public func restoreMasterKey() async throws -> Data {
        try Data(contentsOf: resourceLocator.masterKeyURL)
    }
    
}
