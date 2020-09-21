import Crypto
import Localization
import Store

typealias BankCardItemVendor = BankCardItem.Vendor
typealias BiometricKeychainAvailablity = BiometricKeychain.Availablity
typealias FileItemFormat = FileItem.Format
typealias SecureItemTypeIdentifier = SecureItem.TypeIdentifier
typealias VaultItemInfo = VaultItem.Info
typealias Vault = Store.Vault<CryptoKey, SecureDataHeader, SecureDataMessage>

extension CryptoKey: KeyRepresentable {}
extension SecureDataHeader: HeaderRepresentable {}
extension SecureDataMessage: MessageRepresentable {}

extension SecureItemTypeIdentifier {
    
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
    
}
