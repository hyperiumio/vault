import Foundation

public protocol MasterKeyRepresentable {
    
    associatedtype DerivedKey
    
    init()
    init(from data: Data, using derivedKey: DerivedKey) throws
    
    static var containerSize: Int { get }
    
    func encryptedContainer(using derivedKey: DerivedKey) throws -> Data
    
}

