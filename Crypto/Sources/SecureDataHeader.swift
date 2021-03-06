import CryptoKit
import Foundation

public struct SecureDataHeader {
    
    public let elements: [Element]
    let wrappedItemKey: Data
    
    init(elements: [Element], wrappedItemKey: Data) {
        self.elements = elements
        self.wrappedItemKey = wrappedItemKey
    }
    
    public init(data: Data) throws {
        try self.init { range in
            let lowerBound = data.startIndex + range.startIndex
            let range = Range(lowerBound: lowerBound, count: range.count)
            guard data.startIndex <= range.startIndex, data.endIndex >= range.endIndex else {
                throw CryptoError.invalidDataSize
            }
            
            return data[range]
        }
    }
    
    public init(from dataProvider: (Range<Int>) throws -> Data) throws {
        let messageCountRange = Range(lowerBound: 0, count: UInt32CodingSize)
        let messageCountData = try dataProvider(messageCountRange)
        let rawMessageCount = try UInt32Decode(messageCountData)
        let messageCount = Int(rawMessageCount)
        
        let headerEncodingSize = UInt32CodingSize * messageCount + .wrappedKeySize + .tagSize * messageCount
        let headerRange = Range(lowerBound: messageCountRange.upperBound, count: headerEncodingSize)
        let headerData = try dataProvider(headerRange)
        
        let ciphertextSizes = try (0 ..< messageCount).map { index in
            let ciphertextSizeLowerBound = headerData.startIndex + index * UInt32CodingSize
            let ciphertextSizeRange = Range(lowerBound: ciphertextSizeLowerBound, count: UInt32CodingSize)
            let ciphertextSizeData = headerData[ciphertextSizeRange]
            let rawCiphertextSize = try UInt32Decode(ciphertextSizeData)
            return Int(rawCiphertextSize)
        } as [Int]
        
        let itemKeyRangeLowerBound = headerData.startIndex + messageCount * UInt32CodingSize
        let itemKeyRange = Range(lowerBound: itemKeyRangeLowerBound, count: .wrappedKeySize)
        let itemKey = headerData[itemKeyRange]
        
        let tags = (0 ..< messageCount).map { index in
            let tagRangeLowerBound = itemKeyRange.upperBound + index * .tagSize
            let tagRange = Range(lowerBound: tagRangeLowerBound, count: .tagSize)
            return headerData[tagRange]
        } as [Data]
        
        var nonceRangeLowerBound = UInt32CodingSize + UInt32CodingSize * messageCount + .wrappedKeySize + .tagSize * messageCount
        let nonceRanges = ciphertextSizes.map { ciphertextSize in
            defer {
                nonceRangeLowerBound += .nonceSize + ciphertextSize
            }
            return Range(lowerBound: nonceRangeLowerBound, count: .nonceSize)
        } as [Range<Int>]
        
        var ciphertextRangeLowerBound = UInt32CodingSize + UInt32CodingSize * messageCount + .wrappedKeySize + .tagSize * messageCount + .nonceSize
        let ciphertextRanges = ciphertextSizes.map { ciphertextSize in
            defer {
                ciphertextRangeLowerBound += ciphertextSize + .nonceSize
            }
            return Range(lowerBound: ciphertextRangeLowerBound, count: ciphertextSize)
        } as [Range<Int>]
        
        let elements = (0 ..< messageCount).map { index in
            let nonceRange = nonceRanges[index]
            let ciphertextRange = ciphertextRanges[index]
            let tag = tags[index]
            
            return (nonceRange, ciphertextRange, tag)
        } as [Element]
        
        self.wrappedItemKey = itemKey
        self.elements = elements
    }
    
    public func unwrapKey(with masterKey: MasterKey) throws -> MessageKey {
        let tagSegment = elements.map(\.tag).reduce(Data(), +)
        let wrappedItemKey = try AES.GCM.SealedBox(combined: self.wrappedItemKey)
        
        return try AES.GCM.open(wrappedItemKey, using: masterKey.value, authenticating: tagSegment).withUnsafeBytes(MessageKey.init)
    }
    
}

extension SecureDataHeader {
    
    public typealias Element = (nonceRange: Range<Int>, ciphertextRange: Range<Int>, tag: Data)
    
}

private extension Int {
    
    static let nonceSize = 12
    static let wrappedKeySize = 60
    static let tagSize = 16
    
}

private extension Range where Bound == Int {
    
    init(lowerBound: Bound, count: Int) {
        self = lowerBound ..< lowerBound + count
    }
    
}
