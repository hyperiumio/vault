import Foundation

public protocol CryptoKeyRepresentable {
    
    init()
    init(fromDerivedKeyContainer container: Data, password: String) throws
    init(fromEncryptedKeyContainer container: Data, using derivedKey: Self) throws
    
    func encryptedKeyContainer(using derivedKey: Self) throws -> Data
    
    static var derivedKeyContainerSize: Int { get }
    static var encryptedKeyContainerSize: Int { get }
    
    static func derive(from password: String) throws -> (container: Data, key: Self)
    
}
