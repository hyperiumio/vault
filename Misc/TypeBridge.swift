import Crypto
import Localization
import Store
import SwiftUI
import UniformTypeIdentifiers

typealias BankCardItemVendor = Store.BankCardItem.Vendor
typealias KeychainAvailability = Crypto.Keychain.Availability
typealias SecureItemType = Store.SecureItemType
typealias VaultItemInfo = Store.VaultItemInfo
typealias Vault = Store.Vault<CryptoKey, SecureDataHeader, SecureDataMessage>

extension CryptoKey: KeyRepresentable {}
extension SecureDataHeader: HeaderRepresentable {}
extension SecureDataMessage: MessageRepresentable {}
