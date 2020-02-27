import Foundation

struct DataContainer {
    
    private let elements: [Data]
    
    func encode() throws -> Data {
        return try elements.reduce(.empty) { result, data in
            let encodedSize = try UnsignedInteger32BitEncode(data.count)
            return result + encodedSize + data
        }
    }
    
    subscript(index: Int) -> Data? {
        guard elements.indices.contains(index) else {
            return nil
        }
        return elements[index]
    }
    
}

extension DataContainer: ExpressibleByArrayLiteral {
    
    init(arrayLiteral elements: Data...) {
        self.elements = elements
    }
    
}

extension DataContainer {
    
    static func decode(data: Data) throws -> DataContainer {
        var currentIndex = 0
        var elements = [Data]()
        
        while currentIndex < data.endIndex {
            let elementSizeRange = Range(lowerBound: currentIndex, count: UnsignedInteger32BitEncodingSize)
            guard elementSizeRange.upperBound <= data.endIndex else {
                throw CodingError.decodingFailed
            }
            let elementSize = try data[elementSizeRange].transform { data in
                return try UnsignedInteger32BitDecode(data: data)
            }
            currentIndex += UnsignedInteger32BitEncodingSize
            
            let elementRange = Range(lowerBound: currentIndex, count: elementSize)
            guard elementRange.upperBound <= data.endIndex else {
                throw CodingError.decodingFailed
            }
            let element = data[elementRange]
            currentIndex += element.count
            
            elements.append(element)
        }
        
        return DataContainer(elements: elements)
    }
    
}
