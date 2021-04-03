import CryptoKit
import Foundation
import LocalAuthentication
import Security

public struct Keychain {
    
    private let attributeBuilder: KeychainAttributeBuilder
    private let configuration: Configuration
    
    public init(accessGroup: String, configuration: Configuration = .production) {
        self.attributeBuilder = KeychainAttributeBuilder(accessGroup: accessGroup)
        self.configuration = configuration
    }
    
    public func storeSecret<D>(_ secret: D, forKey key: String) async throws where D: ContiguousBytes {
        try await Self.operationQueue.dispatch {
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
    }
    
    public func loadSecret(forKey key: String) async throws -> Data? {
        try await Self.operationQueue.dispatch {
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
    }
    
    public func deleteSecret(forKey key: String) async throws {
        try await Self.operationQueue.dispatch {
            let deleteQuery = attributeBuilder.buildDeleteAttributes(key: key)
            let status = configuration.delete(deleteQuery)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw CryptoError.keychainDeleteFailed
            }
        }
    }
    
    public func availability() async -> Availability {
        return await Self.operationQueue.dispatch { [configuration] in
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
    
    public struct Configuration {
        
        let context: KeychainContext
        let store: (_ attributes: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let load: (_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
        let delete: (_ query: CFDictionary) -> OSStatus
        
        public static let production = Configuration(context: LAContext(), store: SecItemAdd, load: SecItemCopyMatching, delete: SecItemDelete)
        
    }
    
    public enum BiometryType: Equatable {
        
        case touchID
        case faceID
        
    }
    
    public enum Availability: Equatable {
        
        case notAvailable
        case notEnrolled
        case enrolled(BiometryType)
        
    }
    
}

extension Keychain {
    
    private static let operationQueue = DispatchQueue(label: "KeychainOperationQueue")
    
}

protocol KeychainContext: AnyObject {
    
    var biometryType: LABiometryType { get }
    
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    
}

extension LAContext: KeychainContext {}

private extension DispatchQueue {
    
    func dispatch<T>(body: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            async {
                let result = Result(catching: body)
                continuation.resume(with: result)
            }
        }
    }
    
    func dispatch<T>(body: @escaping () -> T) async -> T {
        await withCheckedContinuation { continuation in
            async {
                let value = body()
                continuation.resume(returning: value)
            }
        }
    }
    
}
