import Foundation

struct SecureDataByteBuffer {

    private let aesKeyRange: Range<Int>
    private let hmacKeyRange: Range<Int>
    private let tagSegmentTagRange: Range<Int>
    private let tagRanges: [Range<Int>]
    private let ciphertextRanges: [Range<Int>]

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

    func readAesKey(from context: ByteBufferContext) throws -> Data {
        return try context.bytes(in: aesKeyRange)
    }

    func readHmacKey(from context: ByteBufferContext) throws -> Data {
        return try context.bytes(in: hmacKeyRange)
    }

    func readTagSegmentTag(from context: ByteBufferContext) throws -> Data {
        return try context.bytes(in: tagSegmentTagRange)
    }

    func readTags(from context: ByteBufferContext) throws -> [Data] {
        return try tagRanges.map { tagRange in
            try context.bytes(in: tagRange)
        }
    }

    func readCiphertext(at index: Int, from context: ByteBufferContext) throws -> Data {
        guard ciphertextRanges.indices.contains(index) else {
            throw Error.invalidIndex
        }

        let ciphertextRange = ciphertextRanges[index]
        return try context.bytes(in: ciphertextRange)
    }
    
}

extension SecureDataByteBuffer {

    static func encode(aesKey: Data, hmacKey: Data, tagSegmentTag: Data, secureContainers: [SecureContainer]) throws -> Data {
        let messageCountSegment = try UnsignedInteger32BitEncode(secureContainers.count)
        
        let ciphertextSizeSegment = try secureContainers.reduce(.empty) { result, secureContainer in
            let ciphertextSize = try UnsignedInteger32BitEncode(secureContainer.ciphertext.count)
            return result + ciphertextSize
        } as Data
        
        let tagSegment = secureContainers.map(\.tag).reduce(.empty, +)
        
        let ciphertextSegment = secureContainers.map(\.ciphertext).reduce(.empty, +)

        return messageCountSegment + ciphertextSizeSegment + aesKey + hmacKey + tagSegmentTag + tagSegment + ciphertextSegment
    }

}

extension SecureDataByteBuffer {
    
    enum Error: Swift.Error {
        
        case invalidIndex
        case invalidMessageCount
        case invalidCiphertextSize
        
    }
    
    struct SecureContainer {
        
        let ciphertext: Data
        let tag: Data
        
    }
    
}

private extension Int {

    static let unsignedInteger32BitSize = 4
    static let wrappedKeySize = 40
    static let tagSize = 16
    static let tagSegmentTagSize = 32

}
