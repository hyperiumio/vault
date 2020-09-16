import CryptoKit
import Foundation

public struct SecureDataHeader {
    
    public let tags: [Data]
    public let nonceRanges: [Range<Int>]
    public let ciphertextRange: [Range<Int>]
    
    private let itemKey: Data
    
    public init(data: (Range<Int>) throws -> Data) throws {
        let messageCountRange = Range(lowerBound: 0, count: UnsignedInteger32BitEncodingSize)
        let messageCountData = try data(messageCountRange)
        precondition(messageCountData.count == UnsignedInteger32BitEncodingSize)
        let messageCount = UnsignedInteger32BitDecode(messageCountData) as Int
        
        let headerEncodingSize = UnsignedInteger32BitEncodingSize * messageCount + .wrappedKeySize + .tagSize * messageCount
        let headerRange = Range(lowerBound: messageCountRange.upperBound, count: headerEncodingSize)
        let headerData = try data(headerRange)
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
        
        self.itemKey = itemKey
        self.tags = tags
        self.nonceRanges = nonceRanges
        self.ciphertextRange = ciphertextRanges
    }
    
    public func unwrapKey(with masterKey: CryptoKey) throws -> CryptoKey {
        let tagSegment = tags.reduce(.empty, +)
        let wrappedItemKey = try AES.GCM.SealedBox(combined: itemKey)
        
        return try AES.GCM.open(wrappedItemKey, using: masterKey.value, authenticating: tagSegment).withUnsafeBytes { itemKey in
            CryptoKey(data: itemKey)
        }
    }
    
}

private extension Int {
    
    static let nonceSize = 12
    static let wrappedKeySize = 60
    static let tagSize = 16
    
}
