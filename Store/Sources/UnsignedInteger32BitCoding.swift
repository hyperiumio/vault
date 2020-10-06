import Foundation

let UnsignedInteger32BitEncodingSize = 4

func UnsignedInteger32BitEncode(_ value: UInt32) -> Data {
    let bytes = [0, 8, 16, 24].map { shift in
        return UInt8(truncatingIfNeeded: value >> shift)
    }
    
    return Data(bytes)
}

func UnsignedInteger32BitEncode(_ value: Int) -> Data {
    let value = UInt32(value)
    return UnsignedInteger32BitEncode(value)
}

func UnsignedInteger32BitDecode(_ data: Data) -> UInt32 {
    precondition(data.count == UnsignedInteger32BitEncodingSize)
    
    return data.enumerated().map { index, byte in
        return UInt32(byte) << (index * 8)
    }.reduce(0, |)
}

func UnsignedInteger32BitDecode(_ data: Data) -> Int {
    let value = UnsignedInteger32BitDecode(data) as UInt32
    
    return Int(value)
}
