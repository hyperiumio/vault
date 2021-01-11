import Combine
import CryptoKit
import Foundation
import LocalAuthentication
import Security

public class Keychain {
    
    private let attributeBuilder: AttributeBuilder
    private let configuration: Configuration
    private let operationQueue = DispatchQueue(label: "KeychainOperationQueue")
    private let availabilityDidChangeSubject: CurrentValueSubject<Availability, Never>
    
    public var availability: Availability {
        availabilityDidChangeSubject.value
    }
    
    public var availabilityDidChange: AnyPublisher<Availability, Never> {
        availabilityDidChangeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public init(accessGroup: String, configuration: Configuration = .production) {
        let availability = Availability(from: configuration.context)
        let availabilityDidChangeSubject = CurrentValueSubject<Availability, Never>(availability)
        
        self.attributeBuilder = AttributeBuilder(accessGroup: accessGroup)
        self.availabilityDidChangeSubject = availabilityDidChangeSubject
        self.configuration = configuration
    }
    
    public func storeSecret<D>(_ secret: D, forKey key: String) -> AnyPublisher<Void, Error> where D: ContiguousBytes {
        operationQueue.future { [attributeBuilder, configuration] in
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
        .eraseToAnyPublisher()
    }
    
    public func loadSecret(forKey key: String) -> AnyPublisher<Data?, Error> {
        operationQueue.future { [attributeBuilder, configuration] in
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
        .eraseToAnyPublisher()
    }
    
    public func deleteSecret(forKey key: String) -> AnyPublisher<Void, Error> {
        operationQueue.future { [attributeBuilder, configuration] in
            let deleteQuery = attributeBuilder.buildDeleteAttributes(key: key)
            let status = configuration.delete(deleteQuery)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw CryptoError.keychainDeleteFailed
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func invalidateAvailability() {
        availabilityDidChangeSubject.value = Availability(from: configuration.context)
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
        
        init(from context: KeychainContext) {
            var error: NSError?
            let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            let biometryType = context.biometryType
            
            switch (canEvaluate, biometryType, error?.code) {
            case (true, .touchID, _):
                self = .enrolled(.touchID)
            case (true, .faceID, _):
                self = .enrolled(.faceID)
            case (false, _, LAError.biometryNotEnrolled.rawValue):
                self = .notEnrolled
            default:
                self = .notAvailable
            }
        }
        
    }
    
}

protocol KeychainContext: AnyObject {
    
    var biometryType: LABiometryType { get }
    
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    
}

extension LAContext: KeychainContext {}

private struct AttributeBuilder {
    
    let accessGroup: String
    
    func buildAddAttributes<D>(key: String, data: D, context: KeychainContext) -> CFDictionary where D: ContiguousBytes {
        [
            kSecClass: kSecClassGenericPassword,
            kSecUseDataProtectionKeychain: true,
            kSecAttrAccessControl: SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil) as Any,
            kSecAttrAccount: key,
            kSecUseAuthenticationContext: context,
            kSecAttrAccessGroup: accessGroup,
            kSecValueData: data.withUnsafeBytes { bytes in
                Data(bytes)
            }
        ] as CFDictionary
    }
    
    func buildDeleteAttributes(key: String) -> CFDictionary {
        [
            kSecClass: kSecClassGenericPassword,
            kSecUseDataProtectionKeychain: true,
            kSecAttrAccount: key,
            kSecAttrAccessGroup: accessGroup
        ] as CFDictionary
    }
    
    func buildLoadAttributes(key: String) -> CFDictionary {
        [
            kSecClass: kSecClassGenericPassword,
            kSecUseDataProtectionKeychain: true,
            kSecAttrAccount: key,
            kSecAttrAccessGroup: accessGroup,
            kSecReturnData: true
        ] as CFDictionary
    }
    
}

private extension DispatchQueue {
    
    func future<Success>(catching body: @escaping () throws -> Success) -> Future<Success, Error> {
        Future { promise in
            self.async {
                let result = Result(catching: body)
                promise(result)
            }
        }
    }
    
}
