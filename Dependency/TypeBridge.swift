import Crypto
import Storage

typealias Store = Storage.Store<CryptoKey, SecureDataHeader, SecureDataMessage>
typealias EncryptedStore = Storage.EncryptedStore<CryptoKey, SecureDataHeader, SecureDataMessage>

extension CryptoKey: CryptoKeyRepresentable {}
extension SecureDataHeader: HeaderRepresentable {}
extension SecureDataMessage: MessageRepresentable {}
