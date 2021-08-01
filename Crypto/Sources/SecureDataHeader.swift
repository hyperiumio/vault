import CryptoKit
import Foundation

struct SecureDataHeader {
    
    public let elements: [Element]
    let wrappedMessageKey: Data
    
    init(with elements: [Element], encryptedBy wrappedMessageKey: Data) {
        self.elements = elements
        self.wrappedMessageKey = wrappedMessageKey
    }
    
    init(data: Data) throws {
        try self.init { range in
            let lowerBound = data.startIndex + range.startIndex
            let range = Range(lowerBound: lowerBound, count: range.count)
            guard data.startIndex <= range.startIndex, data.endIndex >= range.endIndex else {
                throw CryptoError.invalidDataSize
            }
            
            return data[range]
        }
    }
    
    init(from dataProvider: (Range<Int>) throws -> Data) throws {
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
        
        let wrappedMessageKeyRangeLowerBound = headerData.startIndex + messageCount * UInt32CodingSize
        let wrappedMessageKeyRange = Range(lowerBound: wrappedMessageKeyRangeLowerBound, count: .wrappedKeySize)
        let wrappedMessageKey = headerData[wrappedMessageKeyRange]
        
        let tags = (0..<messageCount).map { index in
            let tagRangeLowerBound = wrappedMessageKeyRange.upperBound + index * .tagSize
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
        
        let elements = (0..<messageCount).map { index in
            let nonceRange = nonceRanges[index]
            let ciphertextRange = ciphertextRanges[index]
            let tag = tags[index]
            
            return Element(nonceRange: nonceRange, ciphertextRange: ciphertextRange, tag: tag)
        } as [Element]
        
        self.wrappedMessageKey = wrappedMessageKey
        self.elements = elements
    }
    
    func unwrapMessageKey(with masterKey: MasterKey) throws -> MessageKey {
        let tagSegment = elements.map(\.tag).reduce(Data(), +)
        let wrappedMessageKey = try AES.GCM.SealedBox(combined: self.wrappedMessageKey)
        
        return try AES.GCM.open(wrappedMessageKey, using: masterKey.value, authenticating: tagSegment).withUnsafeBytes(MessageKey.init)
    }
    
}

extension SecureDataHeader {
    
    struct Element: Equatable {
        
        let nonceRange: Range<Int>
        let ciphertextRange: Range<Int>
        let tag: Data
        
        init(nonceRange: Range<Int>, ciphertextRange: Range<Int>, tag: Data) {
            self.nonceRange = nonceRange
            self.ciphertextRange = ciphertextRange
            self.tag = tag
        }
        
    }
    
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
