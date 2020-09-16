public enum CryptoError: Error {
    
    case keychainStoreDidFail
    case keychainLoadDidFail
    case keychainDeleteDidFail
    case keyDerivationFailure
    case invalidDataSize
    case encryptionFailed
    case rngFailure
    
}
