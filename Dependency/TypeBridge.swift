import Crypto
import Store

typealias Vault = Store.Vault<CryptoKey, SecureDataHeader, SecureDataMessage>
typealias VaultContainer = Store.VaultContainer<CryptoKey, SecureDataHeader, SecureDataMessage>

extension CryptoKey: CryptoKeyRepresentable {}
extension SecureDataHeader: HeaderRepresentable {}
extension SecureDataMessage: MessageRepresentable {}
