import Foundation

public struct FileItem: SecureItemValue, Equatable  {
    
    public let name: String
    public let data: Data?
    
    public var format: Format {
        let fileExtension = (name as NSString).pathExtension
        return Format(fileExtension)
    }
    
    var type: SecureItemType { .file }
    
    public init(name: String, data: Data?) {
        self.name = name
        self.data = data
    }
    
    init(from fileItemData: Data) throws {
        guard fileItemData.count >= UnsignedInteger32BitEncodingSize else {
            throw StoreError.decodingFailed
        }
        
        let infoSizeDataRange = Range(fileItemData.startIndex, count: UnsignedInteger32BitEncodingSize)
        let infoSizeData = fileItemData[infoSizeDataRange]
        let infoSize = UnsignedInteger32BitDecode(infoSizeData) as Int
        
        guard fileItemData.count >= UnsignedInteger32BitEncodingSize + infoSize else {
            throw StoreError.decodingFailed
        }
        
        let infoSegmentRange = Range(infoSizeDataRange.upperBound, count: infoSize)
        let infoSegment = fileItemData[infoSegmentRange]
        let info = try JSONDecoder().decode(CodableFileItem.self, from: infoSegment)
        
        guard fileItemData.count >= UnsignedInteger32BitEncodingSize + infoSize + UnsignedInteger32BitEncodingSize else {
            throw StoreError.decodingFailed
        }
        
        let dataSizeDataRange = Range(infoSegmentRange.upperBound, count: UnsignedInteger32BitEncodingSize)
        let dataSizeData = fileItemData[dataSizeDataRange]
        let dataSize = UnsignedInteger32BitDecode(dataSizeData) as Int
        
        guard fileItemData.count == UnsignedInteger32BitEncodingSize + infoSize + UnsignedInteger32BitEncodingSize + dataSize else {
            throw StoreError.decodingFailed
        }
        
        let dataSegmentRange = Range(dataSizeDataRange.upperBound, count: dataSize)
        let dataSegment = fileItemData[dataSegmentRange]
        
        self.name = info.name
        self.data = dataSegment.isEmpty ? nil : dataSegment
    }
    
    func encoded() throws -> Data {
        let encodableItem = CodableFileItem(name: name)
        let encodedItem = try JSONEncoder().encode(encodableItem)
        let encodedItemSize = UnsignedInteger32BitEncode(encodedItem.count)
        let encodedDataSize = UnsignedInteger32BitEncode(data?.count ?? 0)
        let encodedData = data ?? Data()
        
        return encodedItemSize + encodedItem + encodedDataSize + encodedData
    }
    
}

public extension FileItem {
    
    enum Format {
        
        case pdf
        case image
        case unrepresentable
        
        init(_ fileExtension: String) {
            switch fileExtension.lowercased() {
            case "pdf":
                self = .pdf
            case "png", "jpg", "jpeg", "gif", "tif", "tiff", "bmp":
                self = .image
            default:
                self = .unrepresentable
            }
        }
        
    }
    
}

private struct CodableFileItem: Codable {
    
    let name: String
    
}
