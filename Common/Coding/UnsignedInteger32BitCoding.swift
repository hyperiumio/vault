import Foundation

let UnsignedInteger32BitEncodingSize = 4

func UnsignedInteger32BitEncode(_ value: Int) throws -> Data {
    guard let value = UInt32(exactly: value) else {
        throw CodingError.encodingFailed
    }

    let bytes = [
        UInt8(truncatingIfNeeded: value),
        UInt8(truncatingIfNeeded: value >> 8),
        UInt8(truncatingIfNeeded: value >> 16),
        UInt8(truncatingIfNeeded: value >> 24)
    ]
    
    return Data(bytes)
}

func UnsignedInteger32BitDecode(data: Data) throws -> Int {
    guard data.count == UnsignedInteger32BitEncodingSize else {
        throw CodingError.decodingFailed
    }
    
    let byte0 = data[0]
    let byte1 = data[1]
    let byte2 = data[2]
    let byte3 = data[3]
    
    let value0 = UInt32(byte0)
    let value1 = UInt32(byte1) << 8
    let value2 = UInt32(byte2) << 16
    let value3 = UInt32(byte3) << 24
    
    guard let result = Int(exactly: value0 | value1 | value2 | value3) else {
        throw CodingError.decodingFailed
    }
    
    return result
}
