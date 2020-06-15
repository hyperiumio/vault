import CryptoKit
import Foundation
import LocalAuthentication
import Security

var BiometricKeychainWrite = SecItemAdd
var BiometricKeychainLoad = SecItemCopyMatching
var BiometricKeychainDelete = SecItemDelete

public class BiometricKeychain {
    
    private init() {
        
    }
    
    public func storePassword(_ password: String, identifier: String) throws {
        try deletePassword(identifier: identifier)
        
        let password = Data(password.utf8)
        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: identifier,
            kSecAttrAccessControl: access as Any,
            kSecUseAuthenticationContext: LAContext(),
            kSecValueData: password
        ] as CFDictionary
        
        let status = BiometricKeychainWrite(query, nil)
        guard status == errSecSuccess else {
            throw BiometricKeychainError.storeDidFail
        }
    }
    
    public func loadPassword(identifier: String) throws -> String {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: identifier,
            kSecReturnData: true
        ] as CFDictionary
        
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
    
    public func deletePassword(identifier: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: identifier
        ] as CFDictionary
        
        let status = BiometricKeychainDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw BiometricKeychainError.deleteDidFail
        }
    }
    
}

extension BiometricKeychain {
    
    public static let shared = BiometricKeychain()
    
}

public enum BiometricKeychainError: Error {
    
    case storeDidFail
    case loadDidFail
    case deleteDidFail
    
}
