import CommonCrypto

enum RandomBytesError: Error {
    
    case randomNumberGeneratorFailure
    
}

func RandomBytes(count: Int) throws -> [UInt8] {
    var bytes = [UInt8](repeating: 0, count: count)
    
    let status = CCRandomGenerateBytes(&bytes, count)
    guard status == kCCSuccess else {
        throw RandomBytesError.randomNumberGeneratorFailure
    }
   
    return bytes
}
