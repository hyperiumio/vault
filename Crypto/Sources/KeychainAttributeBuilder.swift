import Foundation

struct KeychainAttributeBuilder {
    
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
