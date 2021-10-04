import CryptoKit
import Foundation
import LocalAuthentication
import Security

actor Keychain {
    
    let attributeBuilder: KeychainAttributeBuilder
    let configuration: Configuration
    
    init(accessGroup: String, configuration: Configuration = .production) {
        let builderConfiguration = KeychainAttributeBuilder.Configuration(accessControlCreate: configuration.accessControlCreate)
        
        self.attributeBuilder = KeychainAttributeBuilder(accessGroup: accessGroup, configuration: builderConfiguration)
        self.configuration = configuration
    }
    
    func storeSecret<D>(_ secret: D, forKey key: String, access: KeychainItemAccess) async throws where D: ContiguousBytes {
        let deleteQuery = attributeBuilder.buildDeleteAttributes(key: key)
        let deleteStatus = configuration.delete(deleteQuery)
        guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
            throw CryptoError.keychainDeleteFailed
        }
        
        let addAttributes = attributeBuilder.buildAddAttributes(key: key, data: secret, access: access, context: configuration.context)
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
    
    #if os(iOS)
    var extendedUnlock: ExtendedUnlock {
        get async {
            var canEvaluateBiometricsError: NSError?
            let canEvaluateBiometrics = configuration.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &canEvaluateBiometricsError)
            let biometryType = configuration.context.biometryType
            
            guard
                canEvaluateBiometricsError == nil,
                canEvaluateBiometrics
            else {
                return ExtendedUnlock(touchID: false, faceID: false, watch: false)
            }
            
            switch biometryType {
            case .touchID:
                return ExtendedUnlock(touchID: true, faceID: false, watch: false)
            case .faceID:
                return ExtendedUnlock(touchID: false, faceID: true, watch: false)
            default:
                return ExtendedUnlock(touchID: false, faceID: false, watch: false)
            }
        }
    }
    #endif
    
    #if os(macOS)
    var extendedUnlock: ExtendedUnlock {
        get async {
            var canEvaluateBiometricsError: NSError?
            let canEvaluateBiometrics = configuration.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &canEvaluateBiometricsError)
            let biometryType = configuration.context.biometryType
            
            var canEvaluateWatchError: NSError?
          //  let canEvaluateWatch = configuration.context.canEvaluatePolicy(.de, error: &canEvaluateBiometricsError)
            

        }
    }
    #endif
    
    var biometryAvailablility: BiometryAvailability {
        get async {
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
    
}

extension Keychain {
    
    struct Configuration {
        
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
