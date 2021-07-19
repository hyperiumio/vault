import CryptoKit
import Foundation
import LocalAuthentication
import Security

public actor MasterKeyManager {
    
    public var masterKey: MasterKey
    
    public init(masterKey: MasterKey) {
        self.masterKey = masterKey
    }
    
    public func setMasterKey(_ masterKey: MasterKey) {
        self.masterKey = masterKey
    }
    
}

public actor Keychain {
    
    let attributeBuilder: KeychainAttributeBuilder
    let configuration: Configuration
    
    public init(accessGroup: String, configuration: Configuration = .production) {
        let builderConfiguration = KeychainAttributeBuilder.Configuration(accessControlCreate: configuration.accessControlCreate)
        
        self.attributeBuilder = KeychainAttributeBuilder(accessGroup: accessGroup, configuration: builderConfiguration)
        self.configuration = configuration
    }
    
    public func generateMasterKey(from password: String, publicArguments: DerivedKey.PublicArguments, with id: UUID) async throws -> MasterKey {
        let derivedKey = try await DerivedKey(from: password, with: publicArguments)
        let masterKey = MasterKey()
        let masterKeyContainer = try masterKey.encryptedContainer(using: derivedKey)
        try await self.storeSecret(masterKeyContainer, forKey: "MasterKey")
        
        return masterKey
    }
    
    public func loadMasterKey(with password: String, publicArguments: DerivedKey.PublicArguments, id: UUID) async throws -> MasterKey? {
        guard let masterKeyContainer = try await self.loadSecret(forKey: "MasterKey") else {
            return nil
        }
        let derivedKey = try await DerivedKey(from: password, with: publicArguments)
        return try MasterKey(from: masterKeyContainer, using: derivedKey)
    }
    
    public func loadMasterKeyWithBiometry(id: UUID) async throws -> MasterKey {
        fatalError()
    }
    
    func storeSecret<D>(_ secret: D, forKey key: String) async throws where D: ContiguousBytes {
        let deleteQuery = attributeBuilder.buildDeleteAttributes(key: key)
        let deleteStatus = configuration.delete(deleteQuery)
        guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
            throw CryptoError.keychainDeleteFailed
        }
        
        let addAttributes = attributeBuilder.buildAddAttributes(key: key, data: secret, context: configuration.context)
        let addStatus = configuration.store(addAttributes, nil)
        guard addStatus == errSecSuccess else {
            throw CryptoError.keychainStoreFailed
        }
    }
    
    func loadSecret(forKey key: String) async throws -> Data? {
        let loadQuery = attributeBuilder.buildLoadAttributes(key: key)
        var item: CFTypeRef?
        let status = configuration.load(loadQuery, &item)
        switch status {
        case errSecSuccess:
            guard let data = item as? Data else {
                throw CryptoError.keychainLoadFailed
            }
            return data
        case errSecUserCanceled:
            return nil
        default:
            throw CryptoError.keychainLoadFailed
        }
    }
    
    func deleteSecret(forKey key: String) async throws {
        let deleteQuery = attributeBuilder.buildDeleteAttributes(key: key)
        let status = configuration.delete(deleteQuery)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw CryptoError.keychainDeleteFailed
        }
    }
    
    public func availability() async -> KeychainAvailability {
        var error: NSError?
        let canEvaluate = configuration.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        let biometryType = configuration.context.biometryType
        
        switch (canEvaluate, biometryType, error?.code) {
        case (true, .touchID, _):
            return .enrolled(.touchID)
        case (true, .faceID, _):
            return .enrolled(.faceID)
        case (false, _, LAError.biometryNotEnrolled.rawValue):
            return .notEnrolled
        default:
            return .notAvailable
        }
    }
    
}

extension Keychain {
    
    public struct Configuration {
        
        let context: KeychainContext
        let accessControlCreate: (_ allocator: CFAllocator?, _ protection: CFTypeRef, _ flags: SecAccessControlCreateFlags, _ error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl?
        let store: (_ attributes: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load: (_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete: (_ query: CFDictionary) -> OSStatus
        
        public static var production: Self {
            Self(context: LAContext(), accessControlCreate: SecAccessControlCreateWithFlags, store: SecItemAdd, load: SecItemCopyMatching, delete: SecItemDelete)
        }
        
    }
    
}

extension LAContext: KeychainContext {}
