import CryptoKit
import Foundation

public struct SecureDataHeader {
    
    public let elements: [Element]
    private let itemKey: Data
    
    public init(data: Data) throws {
        try self.init { range in
            let lowerBound = data.startIndex + range.startIndex
            let range = Range(lowerBound: lowerBound, count: range.count)
            return data[range]
        }
    }
    
    public init(from dataProvider: (Range<Int>) throws -> Data) throws {
        let messageCountRange = Range(lowerBound: 0, count: UnsignedInteger32BitEncodingSize)
        let messageCountData = try dataProvider(messageCountRange)
        precondition(messageCountData.count == UnsignedInteger32BitEncodingSize)
        let messageCount = UnsignedInteger32BitDecode(messageCountData) as Int
        
        let headerEncodingSize = UnsignedInteger32BitEncodingSize * messageCount + .wrappedKeySize + .tagSize * messageCount
        let headerRange = Range(lowerBound: messageCountRange.upperBound, count: headerEncodingSize)
        let headerData = try dataProvider(headerRange)
        precondition(headerData.count == headerEncodingSize)
        
        let ciphertextSizes = (0 ..< messageCount).map { index in
            let ciphertextSizeLowerBound = headerData.startIndex + index * UnsignedInteger32BitEncodingSize
            let ciphertextSizeRange = Range(lowerBound: ciphertextSizeLowerBound, count: UnsignedInteger32BitEncodingSize)
            let ciphertextSizeData = headerData[ciphertextSizeRange]
            return UnsignedInteger32BitDecode(ciphertextSizeData)
        } as [Int]
        
        let itemKeyRangeLowerBound = headerData.startIndex + messageCount * UnsignedInteger32BitEncodingSize
        let itemKeyRange = Range(lowerBound: itemKeyRangeLowerBound, count: .wrappedKeySize)
        let itemKey = headerData[itemKeyRange]
        
        let tags = (0 ..< messageCount).map { index in
            let tagRangeLowerBound = itemKeyRange.upperBound + index * .tagSize
            let tagRange = Range(lowerBound: tagRangeLowerBound, count: .tagSize)
            return headerData[tagRange]
        } as [Data]
        
        var nonceRangeLowerBound = UnsignedInteger32BitEncodingSize + UnsignedInteger32BitEncodingSize * messageCount + .wrappedKeySize + .tagSize * messageCount
        let nonceRanges = ciphertextSizes.map { ciphertextSize in
            defer {
                nonceRangeLowerBound += .nonceSize + ciphertextSize
            }
            return Range(lowerBound: nonceRangeLowerBound, count: .nonceSize)
        } as [Range<Int>]
        
        var ciphertextRangeLowerBound = UnsignedInteger32BitEncodingSize + UnsignedInteger32BitEncodingSize * messageCount + .wrappedKeySize + .tagSize * messageCount + .nonceSize
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
        
        self.itemKey = itemKey
        self.elements = elements
    }
    
    public func unwrapKey(with masterKey: MasterKey) throws -> SecureDataKey {
        let tagSegment = elements.map(\.tag).reduce(.empty, +)
        let wrappedItemKey = try AES.GCM.SealedBox(combined: itemKey)
        
        return try AES.GCM.open(wrappedItemKey, using: masterKey.value, authenticating: tagSegment).withUnsafeBytes(SecureDataKey.init)
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
