import Foundation

public actor SystemSecurityService: SecurityService {
    
    public func storeSecret<D>(_ secret: D, forKey key: String) async throws where D : ContiguousBytes {
        fatalError()
    }
    
    public func createKeySet(password: String) async throws -> KeySet {
        fatalError()
    }
    
    public init() throws {}
    
}

public protocol SecurityService {

    func storeSecret<D>(_ secret: D, forKey key: String) async throws where D: ContiguousBytes
    func createKeySet(password: String) async throws -> KeySet
    
}

public extension SecurityService {
    
    typealias KeySet = (derivedKey: DerivedKey, masterKey: MasterKey, derivedKeyContainer: Data, masterKeyContainer: Data)
    
}

/*
func foo() {
    let masterKey = MasterKey()
    let derivedKeyPublicArguments = try DerivedKey.PublicArguments()
    let derivedKey = try DerivedKey(from: password, with: derivedKeyPublicArguments)
    let derivedKeyContainer = derivedKeyPublicArguments.container()
    let masterKeyContainer = try masterKey.encryptedContainer(using: derivedKey)
}
*/
