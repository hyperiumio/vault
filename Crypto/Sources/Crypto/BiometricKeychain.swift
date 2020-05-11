import CryptoKit
import Foundation
import LocalAuthentication
import Security

public enum BiometricKeychainError: Error {
    
    case storeDidFail
    case loadDidFail
    case deleteDidFail
    
}

public func BiometricKeychainStorePassword(_ password: String, identifier: String) throws {
    guard let password = password.data(using: .utf8) else {
        throw BiometricKeychainError.storeDidFail
    }
    
    let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil)
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: identifier,
        kSecAttrAccessControl: access as Any,
        kSecUseAuthenticationContext: LAContext(),
        kSecValueData: password
    ] as CFDictionary
    
    let status = SecItemAdd(query, nil)
    guard status == errSecSuccess else {
        throw BiometricKeychainError.storeDidFail
    }
}

public func BiometricKeychainLoadPassword(identifier: String) throws -> String? {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: identifier,
        kSecReturnData: true
    ] as CFDictionary
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query, &item)
    guard status == errSecSuccess else {
        throw BiometricKeychainError.loadDidFail
    }
    guard let data = item as? Data else {
        throw BiometricKeychainError.loadDidFail
    }
    
    return String(data: data, encoding: .utf8)
}

public func BiometricKeychainDeletePassword(identifier: String) throws {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: identifier
    ] as CFDictionary
    
    let status = SecItemDelete(query)
    guard status == errSecSuccess || status == errSecItemNotFound else {
        throw BiometricKeychainError.deleteDidFail
    }
}

private extension ContiguousBytes {
    
    var dataRepresentation: Data? {
        return self.withUnsafeBytes { bytes in
            let length = bytes.count
            let bytes = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
            return CFDataCreateWithBytesNoCopy(nil, bytes, length, kCFAllocatorNull) as Data?
        }
    }
    
}
