import Foundation

enum CodingError: Error {
    
    case encodingFailed
    case decodingFailed
    
}

func UnsignedInteger32BitEncode(_ value: Int) throws -> [UInt8] {
    guard let value = UInt32(exactly: value) else {
        throw CodingError.encodingFailed
    }

    return [0, 8, 16, 24].map { shift in
        return UInt8(truncatingIfNeeded: value >> shift)
    }
}

func UnsignedInteger32BitDecode(_ bytes: Data) throws -> Int {
    guard bytes.count == 4 else {
        throw CodingError.decodingFailed
    }
    
    let value = bytes.enumerated().map { index, byte in
        return UInt32(byte) << (index * 8)
    }.reduce(0, |)
    
    guard let result = Int(exactly: value) else {
        throw CodingError.decodingFailed
    }
    
    return result
}
