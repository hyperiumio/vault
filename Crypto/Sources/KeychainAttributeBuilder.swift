import Foundation

struct KeychainAttributeBuilder {
    
    let accessGroup: String
    let configuration: Configuration
    
    init(accessGroup: String, configuration: KeychainAttributeBuilder.Configuration = .production) {
        self.accessGroup = accessGroup
        self.configuration = configuration
    }
    
    func buildAddAttributes<D>(key: String, data: D, context: KeychainContext) -> CFDictionary where D: ContiguousBytes {
        [
            kSecClass: kSecClassGenericPassword,
            kSecUseDataProtectionKeychain: true,
            kSecAttrAccessControl: configuration.accessControlCreate(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryCurrentSet, nil) as Any,
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

extension KeychainAttributeBuilder {
    
    public struct Configuration {
        
        let accessControlCreate: (_ allocator: CFAllocator?, _ protection: CFTypeRef, _ flags: SecAccessControlCreateFlags, _ error: UnsafeMutablePointer<Unmanaged<CFError>?>?) -> SecAccessControl?
        
        public static var production: Self {
            Self(accessControlCreate: SecAccessControlCreateWithFlags)
        }
        
    }
    
}
