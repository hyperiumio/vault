import Foundation

public func BackupCreate(at url: URL, write: @escaping (BackupResourceLocator) async throws -> Void) async throws {
    let resourceLocator = BackupResourceLocator(root: url)
    let rootDirectoryAttributes = [FileAttributeKey.extensionHidden: true]
    try? FileManager.default.removeItem(at: resourceLocator.root)
    try FileManager.default.createDirectory(at: resourceLocator.root, withIntermediateDirectories: true, attributes: rootDirectoryAttributes)
    try await write(resourceLocator)
}

public func BackupRestore<T>(from url: URL, read: @escaping (BackupResourceLocator) throws -> T) async throws -> T {
    return try await ExternalResourceRead(url: url) { url in
        let resourceLocator = BackupResourceLocator(root: url)
        return try read(resourceLocator)
    }
}
