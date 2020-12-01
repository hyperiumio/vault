import Combine
import CryptoKit
import Foundation
import LocalAuthentication
import Security

var KeychainWrite = SecItemAdd
var KeychainLoad = SecItemCopyMatching
var KeychainDelete = SecItemDelete

public class Keychain {
    
    public var availabilityDidChange: AnyPublisher<Availability, Never> {
        return availabilityDidChangeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public var availability: Availability { availabilityDidChangeSubject.value }
    
    private let accessGroup: String
    private let identifier: String
    private let operationQueue = DispatchQueue(label: "BiometricKeychainOperationQueue")
    private let context: LAContext
    private let availabilityDidChangeSubject: CurrentValueSubject<Availability, Never>
    
    public init(accessGroup: String, identifier: String) {
        let context = LAContext()
        let availability = Availability(from: context)
        let availabilityDidChangeSubject = CurrentValueSubject<Availability, Never>(availability)
        
        self.accessGroup = accessGroup
        self.identifier = identifier
        self.context = context
        self.availabilityDidChangeSubject = availabilityDidChangeSubject
    }
    
    public func store(_ key: CryptoKey) -> AnyPublisher<Void, Error> {
        operationQueue.future { [accessGroup, identifier, context] in
            let deleteQuery = [
                kSecUseDataProtectionKeychain: true,
                kSecAttrAccessGroup: accessGroup,
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: identifier
            ] as CFDictionary
            
            let writeQuery = [
                kSecUseDataProtectionKeychain: true,
                kSecAttrAccessGroup: accessGroup,
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: identifier,
                kSecAttrAccessControl: SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil) as Any,
                kSecUseAuthenticationContext: context,
                kSecValueData: key.value.withUnsafeBytes { bytes in
                    Data(bytes)
                }
            ] as CFDictionary
            
            let deleteStatus = KeychainDelete(deleteQuery)
            guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
                throw CryptoError.keychainDeleteDidFail
            }
            
            let writeStatus = KeychainWrite(writeQuery, nil)
            guard writeStatus == errSecSuccess else {
                throw CryptoError.keychainStoreDidFail
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func load() -> AnyPublisher<CryptoKey?, Error> {
        operationQueue.future { [accessGroup, identifier] in
            let query = [
                kSecUseDataProtectionKeychain: true,
                kSecAttrAccessGroup: accessGroup,
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: identifier,
                kSecReturnData: true
            ] as CFDictionary
            
            var item: CFTypeRef?
            
            let status = KeychainLoad(query, &item)
            switch status {
            case errSecSuccess:
                guard let data = item as? Data else {
                    throw CryptoError.keychainLoadDidFail
                }
                
                return CryptoKey(data)
            case errSecUserCanceled:
                return nil
            default:
                throw CryptoError.keychainLoadDidFail
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func delete() -> AnyPublisher<Void, Error> {
        operationQueue.future { [accessGroup, identifier] in
            let query = [
                kSecUseDataProtectionKeychain: true,
                kSecAttrAccessGroup: accessGroup,
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: identifier
            ] as CFDictionary
            
            let status = KeychainDelete(query)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw CryptoError.keychainDeleteDidFail
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func invalidateAvailability() {
        availabilityDidChangeSubject.value = Availability(from: context)
    }
    
}

extension Keychain {
    
    public enum BiometryType: Equatable {
        
        case touchID
        case faceID
        
    }
    
    public enum Availability: Equatable {
        
        case notAvailable
        case notEnrolled
        case enrolled(BiometryType)
        
        init(from context: LAContext) {
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
