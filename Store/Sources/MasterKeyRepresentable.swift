import Foundation

public protocol MasterKeyRepresentable {
    
    associatedtype DerivedKey
    
    init()
    init(from data: Data, using derivedKey: DerivedKey) throws
    
    func encrypted(using derivedKey: DerivedKey) throws -> Data
    
}

