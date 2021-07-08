import Foundation
import UniformTypeIdentifiers

public struct FileItem: SecureItemValue, Equatable  {
    
    public let data: Data
    public let type: UTType
    
    public static var secureItemType: SecureItemType { .file }
    
    public init(data: Data, type: UTType) {
        self.data = data
        self.type = type
    }
    
    public init(from fileItemData: Data) throws {
        guard fileItemData.count >= UInt32CodingSize else {
            throw ModelError.decodingFailed
        }
        
        let infoSizeDataRange = Range(fileItemData.startIndex, count: UInt32CodingSize)
        let infoSizeData = fileItemData[infoSizeDataRange]
        let rawInfoSize = try UInt32Decode(infoSizeData)
        let infoSize = Int(rawInfoSize)
        
        guard fileItemData.count >= UInt32CodingSize + infoSize else {
            throw ModelError.decodingFailed
        }
        
        let infoSegmentRange = Range(infoSizeDataRange.upperBound, count: infoSize)
        let infoSegment = fileItemData[infoSegmentRange]
        let info = try JSONDecoder().decode(CodableFileItem.self, from: infoSegment)
        guard let type = UTType(info.type) else {
            throw ModelError.decodingFailed
        }
        
        guard fileItemData.count >= UInt32CodingSize + infoSize + UInt32CodingSize else {
            throw ModelError.decodingFailed
        }
        
        let dataSizeDataRange = Range(infoSegmentRange.upperBound, count: UInt32CodingSize)
        let dataSizeData = fileItemData[dataSizeDataRange]
        let rawDataSize = try UInt32Decode(dataSizeData)
        let dataSize = Int(rawDataSize)
        
        guard fileItemData.count == UInt32CodingSize + infoSize + UInt32CodingSize + dataSize else {
            throw ModelError.decodingFailed
        }
        
        let dataSegmentRange = Range(dataSizeDataRange.upperBound, count: dataSize)
        let dataSegment = fileItemData[dataSegmentRange]
        
        self.data = dataSegment
        self.type = type
    }
    
    public var encoded: Data {
        get throws {
            let encodableItem = CodableFileItem(type: type.identifier)
            let encodedItem = try JSONEncoder().encode(encodableItem)
            let rawItemCount = UInt32(encodedItem.count)
            let encodedItemSize = UInt32Encode(rawItemCount)
            let rawDataSize = UInt32(data.count)
            let encodedDataSize = UInt32Encode(rawDataSize)
            
            return encodedItemSize + encodedItem + encodedDataSize + data
        }
    }
    
}

private struct CodableFileItem: Codable {
    
    let type: String
    
}

private extension Range where Bound == Int {
    
    init(_ lowerBound: Bound, count: Int) {
        self = lowerBound ..< lowerBound + count
    }
    
}

let UInt32CodingSize = 4

func UInt32Encode(_ value: UInt32) -> Data {
    let bytes = [
        UInt8(truncatingIfNeeded: value),
        UInt8(truncatingIfNeeded: value >> 8),
        UInt8(truncatingIfNeeded: value >> 16),
        UInt8(truncatingIfNeeded: value >> 24)
    ]
    
    return Data(bytes)
}

func UInt32Decode(_ data: Data) throws -> UInt32 {
    guard data.count == UInt32CodingSize else {
        throw ModelError.invalidDataSize
    }
    
    let byte0 = data[data.startIndex + 0]
    let byte1 = data[data.startIndex + 1]
    let byte2 = data[data.startIndex + 2]
    let byte3 = data[data.startIndex + 3]
    
    return UInt32(byte0) | UInt32(byte1) << 8 | UInt32(byte2) << 16 | UInt32(byte3) << 24
}

enum ModelError: Error {
    
    case decodingFailed
    case invalidDataSize
    
}
