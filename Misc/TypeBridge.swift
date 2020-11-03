import Crypto
import Localization
import Store
import SwiftUI
import UniformTypeIdentifiers

typealias BankCardItemVendor = Store.BankCardItem.Vendor
typealias KeychainAvailability = Crypto.Keychain.Availability
typealias SecureItemType = Store.SecureItemType
typealias VaultItemInfo = Store.VaultItemInfo
typealias BankAccountItem = Store.BankAccountItem
typealias BankCardItem = Store.BankCardItem
typealias CustomItem = Store.CustomItem
typealias LoginItem = Store.LoginItem
typealias NoteItem = Store.NoteItem
typealias PasswordItem = Store.PasswordItem
typealias WifiItem = Store.WifiItem
typealias FileItem = Store.FileItem
typealias Vault = Store.Vault<CryptoKey, SecureDataHeader, SecureDataMessage>

extension CryptoKey: KeyRepresentable {}
extension SecureDataHeader: HeaderRepresentable {}
extension SecureDataMessage: MessageRepresentable {}
