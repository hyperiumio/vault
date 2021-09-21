import Foundation
import CryptoKit

public typealias CryptorToken = Data


extension CryptorToken {
    
    public static func create() throws -> Self {
        try DerivedKey.PublicArguments().container()
    }
    
}

public actor Cryptor {
    
    private let keychain: Keychain
    private var masterKey: MasterKey?
    
    public init(keychainAccessGroup: String) {
        self.keychain = Keychain(accessGroup: keychainAccessGroup)
    }
    
    public func createMasterKey(from password: String, token: CryptorToken, with id: UUID, usingBiometryUnlock: Bool) async throws {
        let publicArguments = try DerivedKey.PublicArguments(from: token)
        let derivedKey = try DerivedKey(from: password, with: publicArguments)
        let masterKey = MasterKey()
        let masterKeyContainer = try masterKey.encryptedContainer(using: derivedKey)
        
        try await keychain.storeSecret(masterKeyContainer, forKey: .masterKey, access: .all)
        if usingBiometryUnlock {
            try await keychain.storeSecret(derivedKey.value, forKey: .derivedKey, access: .currentBiometry)
        }
        
        self.masterKey = masterKey
    }
    
    public func setMasterKey(wrappedMasterKey: Data, with id: UUID) async throws {
        try await keychain.storeSecret(wrappedMasterKey, forKey: .masterKey, access: .all)
        self.masterKey = nil
    }
    
    public func unlockWithPassword(_ password: String, token: CryptorToken, id: UUID) async throws {
        let publicArguments = try DerivedKey.PublicArguments(from: token)
        let derivedKey = try DerivedKey(from: password, with: publicArguments)
        guard let masterKeyContainer = try await keychain.loadSecret(forKey: .masterKey) else {
            throw CryptoError.masterKeyNotInKeychain
        }
        let masterKey = try MasterKey(from: masterKeyContainer, using: derivedKey)
        
        self.masterKey = masterKey
    }
    
    public func unlockWithBiometry(id: UUID) async throws {
        guard let derivedKeyContainer = try await keychain.loadSecret(forKey: .derivedKey) else {
            throw CryptoError.derivedKeyNotInKeychain
        }
        guard let masterKeyContainer = try await keychain.loadSecret(forKey: .masterKey) else {
            throw CryptoError.masterKeyNotInKeychain
        }
        let derivedKey = DerivedKey(with: derivedKeyContainer)
        let masterKey = try MasterKey(from: masterKeyContainer, using: derivedKey)
        
        self.masterKey = masterKey
    }
    
    public func lock() async {
        masterKey = nil
    }
    
    public func decryptMessages(from container: Data) async throws -> [Data] {
        guard let masterKey = masterKey else {
            throw CryptoError.cryptorNotUnlocked
        }
        
        return try SecureDataMessage.decryptMessages(from: container, using: masterKey)
    }
    
    public func decryptMessage(at index: Int, from container: Data) async throws -> Data {
        guard let masterKey = masterKey else {
            throw CryptoError.cryptorNotUnlocked
        }
        
        return try SecureDataMessage.decryptMessages(from: container, using: masterKey)[index] // hack
    }
    
    public func encryptMessages(_ messages: [Data]) async throws -> Data {
        guard let masterKey = masterKey else {
            throw CryptoError.cryptorNotUnlocked
        }
        
        return try SecureDataMessage.encryptContainer(from: messages, using: masterKey)
    }
    
    public var biometryAvailablility: BiometryAvailability {
        get async {
            await keychain.biometryAvailablility
        }
    }
    
    public var wrappedMasterKey: Data? {
        get async throws {
            try await keychain.loadSecret(forKey: .masterKey)
        }
    }
    
    public func decryptStoreItems<S>(_ items: S) -> AsyncStream<Data> where S: AsyncSequence {
        fatalError()
    }
    
}

private extension String {
    
    static var masterKey: Self { "MasterKey" }
    static var derivedKey: Self { "DerivedKey" }
    
}
