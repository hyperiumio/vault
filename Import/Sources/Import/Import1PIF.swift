import Foundation

public enum ImportError: Error {
    
    case importFailed
    
}

public func Import1PIF(from data: Data) throws -> [VaultItem] {
    throw ImportError.importFailed
}
