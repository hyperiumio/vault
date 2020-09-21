import Combine
import CryptoKit
import Foundation
import LocalAuthentication
import Security

var BiometricKeychainWrite = SecItemAdd
var BiometricKeychainLoad = SecItemCopyMatching
var BiometricKeychainDelete = SecItemDelete

public class BiometricKeychain {
    
    public var availabilityDidChange: AnyPublisher<Availablity, Never> {
        return availabilityDidChangeSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    public var availability: Availablity { availabilityDidChangeSubject.value }
    
    private let identifier: String
    private let operationQueue = DispatchQueue(label: "BiometricKeychainOperationQueue")
    private let context: LAContext
    private let availabilityDidChangeSubject: CurrentValueSubject<Availablity, Never>
    
    public init(identifier: String) {
        let context = LAContext()
        let availability = Availablity(from: context)
        let availabilityDidChangeSubject = CurrentValueSubject<Availablity, Never>(availability)
        
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
            
            let deleteStatus = BiometricKeychainDelete(deleteQuery)
            guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
                throw CryptoError.keychainDeleteDidFail
            }
            
            let writeStatus = BiometricKeychainWrite(writeQuery, nil)
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
            
            let status = BiometricKeychainLoad(query, &item)
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
            
            let status = BiometricKeychainDelete(query)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw CryptoError.keychainDeleteDidFail
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func invalidateAvailability() {
        availabilityDidChangeSubject.value = Availablity(from: context)
    }
    
}

extension BiometricKeychain {
    
    public enum Availablity {
        
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
