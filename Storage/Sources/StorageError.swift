public enum StorageError: Error {
    
    case invalidFileReader
    case invalidByteRange
    case dataNotAvailable
    case decodingFailed
    case invalidPassword
    case invalidStoreItemID
    case invalidStoreID
    case invalidDataSize
    case storeCreationFailed
    case invalidMessageContainer
    
}
