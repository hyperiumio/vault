import Foundation

struct SecureDataItem {
    
    let ciphertext: Data
    let tag: Data
    
}

enum SecureDataCodingError: Error {
    
    case invalidIndex
    case invalidMessageCount
    case invalidCiphertextSize
    
}

struct SecureDataDecodingToken {
    
    let aesKeyRange: Range<Int>
    let hmacKeyRange: Range<Int>
    let tagSegmentTagRange: Range<Int>
    let tagRanges: [Range<Int>]
    let ciphertextRanges: [Range<Int>]
    
    init(from context: ByteBufferContext) throws {
        let messageCountRange = Range(lowerBound: 0, count: .unsignedInteger32BitSize)
        let messageCount = try context.bytes(in: messageCountRange).map { data in
            return try UnsignedInteger32BitDecode(data: data)
        }

        let ciphertextSizes = try (0 ..< messageCount).map { index in
            let ciphertextSizeLowerBound = messageCountRange.upperBound + index * .unsignedInteger32BitSize
            let ciphertextSizeRange = Range(lowerBound: ciphertextSizeLowerBound, count: .unsignedInteger32BitSize)
            return try context.bytes(in: ciphertextSizeRange).map { data in
                return try UnsignedInteger32BitDecode(data: data)
            }
        } as [Int]

        let aesKeyRangeLowerBound = messageCountRange.upperBound + messageCount * .unsignedInteger32BitSize
        let aesKeyRange = Range(lowerBound: aesKeyRangeLowerBound, count: .wrappedKeySize)

        let hmacKeyRange = Range(lowerBound: aesKeyRange.upperBound, count: .wrappedKeySize)

        let tagSegmentTagRange = Range(lowerBound: hmacKeyRange.upperBound, count: .tagSegmentTagSize)

        let tagRanges = (0 ..< messageCount).map { index in
            let tagRangeLowerBound = tagSegmentTagRange.upperBound + index * .tagSize
            return Range(lowerBound: tagRangeLowerBound, count: .tagSize)
        } as [Range<Int>]

        var ciphertextRangeLowerBound = tagSegmentTagRange.upperBound + messageCount * .tagSize
        let ciphertextRanges = ciphertextSizes.map { ciphertextSize in
            defer {
                ciphertextRangeLowerBound += ciphertextSize
            }
            return Range(lowerBound: ciphertextRangeLowerBound, count: ciphertextSize)
        } as [Range<Int>]

        self.aesKeyRange = aesKeyRange
        self.hmacKeyRange = hmacKeyRange
        self.tagSegmentTagRange = tagSegmentTagRange
        self.tagRanges = tagRanges
        self.ciphertextRanges = ciphertextRanges
    }
    
}

func SecureDataEncode(aesKey: Data, hmacKey: Data, tagSegmentTag: Data, secureContainers: [SecureDataItem]) throws -> Data {
    let messageCountSegment = try UnsignedInteger32BitEncode(secureContainers.count)
    
    let ciphertextSizeSegment = try secureContainers.reduce(.empty) { result, secureContainer in
        let ciphertextSize = try UnsignedInteger32BitEncode(secureContainer.ciphertext.count)
        return result + ciphertextSize
    } as Data
    
    let tagSegment = secureContainers.map(\.tag).reduce(.empty, +)
    
    let ciphertextSegment = secureContainers.map(\.ciphertext).reduce(.empty, +)

    return messageCountSegment + ciphertextSizeSegment + aesKey + hmacKey + tagSegmentTag + tagSegment + ciphertextSegment
}

func SecureDataDecodeAesKey(token: SecureDataDecodingToken, context: ByteBufferContext) throws -> Data {
    return try context.bytes(in: token.aesKeyRange)
}

func SecureDataDecodeHmacKey(token: SecureDataDecodingToken, context: ByteBufferContext) throws -> Data {
    return try context.bytes(in: token.hmacKeyRange)
}

func SecureDataDecodeTagSegmentTag(token: SecureDataDecodingToken, context: ByteBufferContext) throws -> Data {
    return try context.bytes(in: token.tagSegmentTagRange)
}

func SecureDataDecodeTags(token: SecureDataDecodingToken, context: ByteBufferContext) throws -> [Data] {
    return try token.tagRanges.map { tagRange in
        try context.bytes(in: tagRange)
    }
}

func SecureDataDecodeCiphertext(token: SecureDataDecodingToken, context: ByteBufferContext, index: Int) throws -> Data {
    guard token.ciphertextRanges.indices.contains(index) else {
        throw SecureDataCodingError.invalidIndex
    }

    let ciphertextRange = token.ciphertextRanges[index]
    return try context.bytes(in: ciphertextRange)
}

private extension Int {

    static let unsignedInteger32BitSize = 4
    static let wrappedKeySize = 40
    static let tagSize = 16
    static let tagSegmentTagSize = 64

}
