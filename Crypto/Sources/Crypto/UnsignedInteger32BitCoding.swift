import Foundation

let UnsignedInteger32BitEncodingSize = 4

func UnsignedInteger32BitEncode(_ value: UInt32) -> Data {
    let bytes = [
        UInt8(truncatingIfNeeded: value),
        UInt8(truncatingIfNeeded: value >> 8),
        UInt8(truncatingIfNeeded: value >> 16),
        UInt8(truncatingIfNeeded: value >> 24)
    ]
    
    return Data(bytes)
}

func UnsignedInteger32BitDecode(_ data: Data) -> UInt32 {
    precondition(data.count == UnsignedInteger32BitEncodingSize)
    
    let byte0 = data[data.startIndex + 0]
    let byte1 = data[data.startIndex + 1]
    let byte2 = data[data.startIndex + 2]
    let byte3 = data[data.startIndex + 3]
    
    return UInt32(byte0) | UInt32(byte1) << 8 | UInt32(byte2) << 16 | UInt32(byte3) << 24
}
