public enum CryptoError: Error {
    
    case keychainStoreFailed
    case keychainLoadFailed
    case keychainDeleteFailed
    case keyDerivationFailed
    case encryptionFailed
    case randomNumberGenerationFailed
    case passwordGenerationFailed
    case invalidDataSize
    case wrongPassword
    
}
