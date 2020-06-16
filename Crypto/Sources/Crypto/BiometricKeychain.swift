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
    
    private let context: LAContext
    private let availabilityDidChangeSubject: CurrentValueSubject<Availablity, Never>
    private let operationQueue = DispatchQueue(label: "BiometricKeychainOperationQueue")
    
    private init() {
        let context = LAContext()
        let availability = Availablity(from: context)
        
        self.context = context
        self.availabilityDidChangeSubject = CurrentValueSubject<Availablity, Never>(availability)
    }
    
    public func storePassword(_ password: String, identifier: String) -> Future<Void, Error> {
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
        
        return Future { [operationQueue] promise in
            operationQueue.async {
                let result = Result {
                    let deleteStatus = BiometricKeychainDelete(deleteQuery)
                    guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
                        throw BiometricKeychainError.deleteDidFail
                    }
                    
                    let writeStatus = BiometricKeychainWrite(writeQuery, nil)
                    guard writeStatus == errSecSuccess else {
                        throw BiometricKeychainError.storeDidFail
                    }
                }
                promise(result)
            }
        }
    }
    
    public func loadPassword(identifier: String) -> Future<String, Error> {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: identifier,
            kSecReturnData: true
        ] as CFDictionary
        
        return Future { [operationQueue] promise in
            operationQueue.async {
                let result = Result<String, Error> {
                    var item: CFTypeRef?
                    
                    let status = BiometricKeychainLoad(query, &item)
                    guard status == errSecSuccess else {
                        throw BiometricKeychainError.loadDidFail
                    }
                    guard let data = item as? Data else {
                        throw BiometricKeychainError.loadDidFail
                    }
                    guard let password = String(data: data, encoding: .utf8) else {
                        throw BiometricKeychainError.loadDidFail
                    }
                    
                    return password
                }
                promise(result)
            }
        }
    }
    
    public func deletePassword(identifier: String) -> Future<Void, Error> {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: identifier
        ] as CFDictionary
        
        return Future { [operationQueue] promise in
            operationQueue.async {
                let result = Result {
                    let status = BiometricKeychainDelete(query)
                    guard status == errSecSuccess || status == errSecItemNotFound else {
                        throw BiometricKeychainError.deleteDidFail
                    }
                }
                promise(result)
            }
        }
    }
    
    public func invalidateAvailability() {
        availabilityDidChangeSubject.value = Availablity(from: context)
    }
    
}

extension BiometricKeychain {
    
    public static let shared = BiometricKeychain()
    
}

extension BiometricKeychain {
    
    public enum Availablity {
        
        case notAvailable
        case notEnrolled
        case notAccessible
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
            case (false, .none, _):
                self = .notAvailable
            case (false, _, LAError.biometryNotEnrolled.rawValue):
                self = .notEnrolled
            default:
                self = .notAccessible
            }
        }
        
    }
    
}

public enum BiometricKeychainError: Error {
    
    case storeDidFail
    case loadDidFail
    case deleteDidFail
    
}
