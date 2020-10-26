import Foundation
import UniformTypeIdentifiers

public struct FileItem: SecureItemValue, Equatable  {
    
    public let data: Data
    public let typeIdentifier: UTType
    
    public var type: SecureItemType { .file }
    
    public init(data: Data, typeIdentifier: UTType) {
        self.data = data
        self.typeIdentifier = typeIdentifier
    }
    
    init(from fileItemData: Data) throws {
        guard fileItemData.count >= UInt32CodingSize else {
            throw StoreError.decodingFailed
        }
        
        let infoSizeDataRange = Range(fileItemData.startIndex, count: UInt32CodingSize)
        let infoSizeData = fileItemData[infoSizeDataRange]
        let infoSize = UInt32Decode(infoSizeData)
        
        guard fileItemData.count >= UInt32CodingSize + infoSize else {
            throw StoreError.decodingFailed
        }
        
        let infoSegmentRange = Range(infoSizeDataRange.upperBound, count: infoSize)
        let infoSegment = fileItemData[infoSegmentRange]
        let info = try JSONDecoder().decode(CodableFileItem.self, from: infoSegment)
        guard let typeIdentifier = UTType(info.typeIdentifier) else {
            throw StoreError.decodingFailed
        }
        
        guard fileItemData.count >= UInt32CodingSize + infoSize + UInt32CodingSize else {
            throw StoreError.decodingFailed
        }
        
        let dataSizeDataRange = Range(infoSegmentRange.upperBound, count: UInt32CodingSize)
        let dataSizeData = fileItemData[dataSizeDataRange]
        let dataSize = UInt32Decode(dataSizeData)
        
        guard fileItemData.count == UInt32CodingSize + infoSize + UInt32CodingSize + dataSize else {
            throw StoreError.decodingFailed
        }
        
        let dataSegmentRange = Range(dataSizeDataRange.upperBound, count: dataSize)
        let dataSegment = fileItemData[dataSegmentRange]
        
        self.data = dataSegment
        self.typeIdentifier = typeIdentifier
    }
    
    public func encoded() throws -> Data {
        let encodableItem = CodableFileItem(typeIdentifier: typeIdentifier.identifier)
        let encodedItem = try JSONEncoder().encode(encodableItem)
        let encodedItemSize = UInt32Encode(encodedItem.count)
        let encodedDataSize = UInt32Encode(data.count)
        
        return encodedItemSize + encodedItem + encodedDataSize + data
    }
    
}

private struct CodableFileItem: Codable {
    
    let typeIdentifier: String
    
}
