import CryptoKit
import Foundation
import LocalAuthentication
import Security

public enum BiometricKeychainError: Error {
    
    case storeDidFail
    case loadDidFail
    case deleteDidFail
    
}

public struct BiometricKeychain {
    
    private let accessControl: AccessControl
    private let write: Write
    private let load: Load
    private let delete: Delete
    
    public init(accessControl: @escaping AccessControl = SecAccessControlCreateWithFlags, write: @escaping Write = SecItemAdd, load: @escaping Load = SecItemCopyMatching, delete: @escaping Delete = SecItemDelete) {
        self.accessControl = accessControl
        self.write = write
        self.load = load
        self.delete = delete
    }
    
    public func storePassword(_ password: String, identifier: String) throws {
        try deletePassword(identifier: identifier)
        
        let password = Data(password.utf8)
        let access = accessControl(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: identifier,
            kSecAttrAccessControl: access as Any,
            kSecUseAuthenticationContext: LAContext(),
            kSecValueData: password
        ] as CFDictionary
        
        let status = write(query, nil)
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
        let status = load(query, &item)
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
        
        let status = delete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw BiometricKeychainError.deleteDidFail
        }
    }
    
}

public extension BiometricKeychain {
    
    typealias AccessControl = (_ allocator: CFAllocator?, _ protection: CFTypeRef, _ flags: SecAccessControlCreateFlags, _ error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl?
    typealias Write = (_ attributes: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
    typealias Load = (_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
    typealias Delete = (_ query: CFDictionary) -> OSStatus
    
}
