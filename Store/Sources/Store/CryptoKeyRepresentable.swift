import Foundation

public protocol CryptoKeyRepresentable: Equatable {
    
    init()
    
    static func encoded(_ key: Self, using password: String) throws -> Data
    static func decoded(from data: Data, using password: String) throws -> Self
    
}
