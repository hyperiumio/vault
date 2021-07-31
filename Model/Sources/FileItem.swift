import Foundation
import UniformTypeIdentifiers

public struct FileItem: Equatable {
    
    public let value: Value?
    
    public init(value: Value? = nil) {
        self.value = value
    }
    
}

extension FileItem: SecureItemValue {
    
    public init(from itemData: Data) throws {
        guard itemData.count >= .codingSize32Bit else {
            throw ModelError.decodingFailed
        }
        
        let infoSizeDataRange = Range(itemData.startIndex, count: .codingSize32Bit)
        let infoSizeData = itemData[infoSizeDataRange]
        let rawInfoSize = try UInt32(from: infoSizeData)
        let infoSize = Int(rawInfoSize)
        
        guard itemData.count >= .codingSize32Bit + infoSize else {
            throw ModelError.decodingFailed
        }
        
        let infoSegmentRange = Range(infoSizeDataRange.upperBound, count: infoSize)
        let infoSegment = itemData[infoSegmentRange]
        let info = try Self.decoder.decode(Info.self, from: infoSegment)
        
        switch (info.type, itemData.count) {
        case (nil, 0):
            self.value = nil
        case (nil, _):
            throw ModelError.invalidDataSize
        case (let type?, _):
            guard let type = UTType(type) else {
                throw ModelError.decodingFailed
            }
            
            guard itemData.count >= .codingSize32Bit + infoSize + .codingSize32Bit else {
                throw ModelError.decodingFailed
            }
            
            let dataSizeDataRange = Range(infoSegmentRange.upperBound, count: .codingSize32Bit)
            let dataSizeData = itemData[dataSizeDataRange]
            let rawDataSize = try UInt32(from: dataSizeData)
            let dataSize = Int(rawDataSize)
            
            guard itemData.count == .codingSize32Bit + infoSize + .codingSize32Bit + dataSize else {
                throw ModelError.decodingFailed
            }
            
            let dataSegmentRange = Range(dataSizeDataRange.upperBound, count: dataSize)
            let dataSegment = itemData[dataSegmentRange]
            
            self.value = Value(data: dataSegment, type: type)
        }
    }
    
    public var encoded: Data {
        get throws {
            let type = value?.type.identifier
            let data = value?.data ?? Data()
            let encodableItem = Info(type: type)
            let encodedItem = try Self.encoder.encode(encodableItem)
            let rawItemCount = UInt32(encodedItem.count)
            let encodedItemSize = rawItemCount.encoded
            let rawDataSize = UInt32(data.count)
            let encodedDataSize = rawDataSize.encoded
            
            return encodedItemSize + encodedItem + encodedDataSize + data
        }
    }
    
    public var secureItemType: SecureItemType { .file }
    
}

public extension FileItem {
    
    struct Value: Equatable {
        
        public let data: Data
        public let type: UTType
        
        public init(data: Data, type: UTType) {
            self.data = data
            self.type = type
        }
        
    }
    
    private struct Info: Codable {
        
        let type: String?
        
    }
    
}

private extension Range where Bound == Int {
    
    init(_ lowerBound: Bound, count: Int) {
        self = lowerBound ..< lowerBound + count
    }
    
}

private extension Int {
    
    static var codingSize32Bit: Int { 4 }
    
}

private extension UInt32 {
    
    init(from data: Data) throws {
        guard data.count == .codingSize32Bit else {
            throw ModelError.invalidDataSize
        }
        
        let byte0 = data[data.startIndex]
        let byte1 = data[data.startIndex + 1]
        let byte2 = data[data.startIndex + 2]
        let byte3 = data[data.startIndex + 3]
        
        self = UInt32(byte0) | UInt32(byte1) << 8 | UInt32(byte2) << 16 | UInt32(byte3) << 24
    }
    
    var encoded: Data {
        let bytes = [
            UInt8(truncatingIfNeeded: self),
            UInt8(truncatingIfNeeded: self >> 8),
            UInt8(truncatingIfNeeded: self >> 16),
            UInt8(truncatingIfNeeded: self >> 24)
        ]
        
        return Data(bytes)
    }
    
}
