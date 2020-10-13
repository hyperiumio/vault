import Crypto
import Localization
import Store
import SwiftUI

typealias BankCardItemVendor = Store.BankCardItem.Vendor
typealias KeychainAvailability = Crypto.Keychain.Availability
typealias FileItemFormat = Store.FileItem.Format
typealias SecureItemType = Store.SecureItemType
typealias VaultItemInfo = Store.VaultItemInfo
typealias Vault = Store.Vault<CryptoKey, SecureDataHeader, SecureDataMessage>

extension CryptoKey: KeyRepresentable {}
extension SecureDataHeader: HeaderRepresentable {}
extension SecureDataMessage: MessageRepresentable {}

extension SecureItemType {
    
    var name: String {
        switch self {
        case .password:
            return LocalizedString.password
        case .login:
            return LocalizedString.login
        case .file:
            return LocalizedString.file
        case .note:
            return LocalizedString.note
        case .bankCard:
            return LocalizedString.bankCard
        case .wifi:
            return LocalizedString.wifi
        case .bankAccount:
            return LocalizedString.bankAccount
        case .custom:
            return LocalizedString.customItem
        }
    }
    
    var image: Image {
        switch self {
        case .password:
            return .password
        case .login:
            return .login
        case .file:
            return .file
        case .note:
            return .note
        case .bankCard:
            return .bankCard
        case .wifi:
            return .wifi
        case .bankAccount:
            return .bankAccount
        case .custom:
            return .custom
        }
    }
    
    var color: Color {
        switch self {
        case .password:
            return .appGray
        case .login:
            return .appBlue
        case .file:
            return .appPink
        case .note:
            return .appYellow
        case .bankCard:
            return .appPurple
        case .wifi:
            return .appTeal
        case .bankAccount:
            return .appGreen
        case .custom:
            return .appRed
        }
    }
    
}

extension BiometricType {
    
    var image: Image {
        switch self {
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }
    
}
