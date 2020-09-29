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
    
    private let identifier: String
    private let operationQueue = DispatchQueue(label: "BiometricKeychainOperationQueue")
    private let context: LAContext
    private let availabilityDidChangeSubject: CurrentValueSubject<Availability, Never>
    
    public init(identifier: String) {
        let context = LAContext()
        let availability = Availability(from: context)
        let availabilityDidChangeSubject = CurrentValueSubject<Availability, Never>(availability)
        
        self.identifier = identifier
        self.context = context
        self.availabilityDidChangeSubject = availabilityDidChangeSubject
    }
    
    public func store(_ password: String) -> AnyPublisher<Void, Error> {
        operationQueue.future { [identifier, context] in
            let deleteQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: identifier
            ] as CFDictionary
            
            let writeQuery = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: identifier,
                kSecAttrAccessControl: SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil) as Any,
                kSecUseAuthenticationContext: context,
                kSecValueData: Data(password.utf8)
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
    
    public func loadPassword() -> AnyPublisher<String, Error> {
        operationQueue.future { [identifier] in
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: identifier,
                kSecReturnData: true
            ] as CFDictionary
            
            var item: CFTypeRef?
            
            let status = KeychainLoad(query, &item)
            guard status == errSecSuccess else {
                throw CryptoError.keychainLoadDidFail
            }
            guard let data = item as? Data else {
                throw CryptoError.keychainLoadDidFail
            }
            guard let password = String(data: data, encoding: .utf8) else {
                throw CryptoError.keychainLoadDidFail
            }
            
            return password
        }
        .eraseToAnyPublisher()
    }
    
    public func deletePassword() -> AnyPublisher<Void, Error> {
        operationQueue.future { [identifier] in
            let query = [
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
    
    public enum Availability {
        
        case notAvailable
        case notEnrolled
        case touchID
        case faceID
        
        init(from context: LAContext) {
            var error: NSError?
            let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            let biometryType = context.biometryType
            
            switch (canEvaluate, biometryType, error?.code) {
            case (true, .touchID, _):
                self = .touchID
            case (true, .faceID, _):
                self = .faceID
            case (false, _, LAError.biometryNotEnrolled.rawValue):
                self = .notEnrolled
            default:
                self = .notAvailable
            }
        }
        
    }
    
}
