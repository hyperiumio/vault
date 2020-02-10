import Foundation

struct SecureDataByteBuffer {

    let segmentCount: Int

    private let aesKeyRange: Range<Int>
    private let hmacKeyRange: Range<Int>
    private let macRange: Range<Int>
    private let tagRanges: [Range<Int>]
    private let segmentRanges: [Range<Int>]

    init(from byteBuffer: ByteBuffer) throws {
        let segmentCountRange = Range(lowerBound: 0, count: .unsignedInteger32BitSize)
        let segmentCount = try byteBuffer.decodeUnsignedInteger32Bit(in: segmentCountRange)

        let segmentSizes = try (0 ..< segmentCount).map { segmentIndex in
            let segmentSizeLowerBound = segmentCountRange.upperBound + segmentIndex * .unsignedInteger32BitSize
            let segmentSizeRange = Range(lowerBound: segmentSizeLowerBound, count: .unsignedInteger32BitSize)
            return try byteBuffer.decodeUnsignedInteger32Bit(in: segmentSizeRange)
        } as [Int]

        let aesKeyRangeLowerBound = segmentCountRange.upperBound + segmentCount * .unsignedInteger32BitSize
        let aesKeyRange = Range(lowerBound: aesKeyRangeLowerBound, count: .wrappedKeySize)

        let hmacKeyRangeLowerBound = aesKeyRange.upperBound
        let hmacKeyRange = Range(lowerBound: hmacKeyRangeLowerBound, count: .wrappedKeySize)

        let macRangeLowerBound = hmacKeyRange.upperBound
        let macRange = Range(lowerBound: macRangeLowerBound, count: .macSize)

        let tagRanges = (0 ..< segmentCount).map { segmentIndex in
            let tagRangeLowerBound = macRange.upperBound + segmentIndex * .tagSize
            return Range(lowerBound: tagRangeLowerBound, count: .tagSize)
        } as [Range<Int>]

        var segmentRangeLowerBound = macRange.upperBound + segmentCount * .tagSize
        let segmentRanges = segmentSizes.map { segmentSize in
            defer {
                segmentRangeLowerBound += segmentSize
            }
            return Range(lowerBound: segmentRangeLowerBound, count: segmentSize)
        } as [Range<Int>]

        self.segmentCount = segmentCount
        self.aesKeyRange = aesKeyRange
        self.hmacKeyRange = hmacKeyRange
        self.macRange = macRange
        self.tagRanges = tagRanges
        self.segmentRanges = segmentRanges
    }

    func readAesKey(from context: ByteBuffer) throws -> Data {
        return try context.bytes(in: aesKeyRange)
    }

    func readHmacKey(from context: ByteBuffer) throws -> Data {
        return try context.bytes(in: hmacKeyRange)
    }

    func readMac(from context: ByteBuffer) throws -> Data {
        return try context.bytes(in: macRange)
    }

    func readTag(at index: Int, from context: ByteBuffer) throws -> Data {
        guard tagRanges.indices.contains(index) else {
            throw Error.invalidSegmentIndex
        }

        let tagRange = tagRanges[index]
        return try context.bytes(in: tagRange)
    }

    func readSegment(at index: Int, from context: ByteBuffer) throws -> Data {
        guard segmentRanges.indices.contains(index) else {
            throw Error.invalidSegmentIndex
        }

        let segmentRange = segmentRanges[index]
        return try context.bytes(in: segmentRange)
    }
    
}

extension SecureDataByteBuffer {

    static func encode(aesKey: Data, hmacKey: Data, tagSegmentTag: Data, secureContainers: [SecureContainer]) throws -> Data {
        guard let segmentCount = UInt32(exactly: secureContainers.count)?.littleEndian.bytes else {
            throw Error.invalidContainerCount
        }
        
        let ciphertextSizesSegment = try secureContainers.reduce(.empty) { result, secureContainers in
            guard let ciphertextSize = UInt32(exactly: secureContainers.ciphertext.count) else {
                throw Error.invalidContainerCount
            }
            return result + ciphertextSize.littleEndian.bytes
        } as Data
        
        let tagSegment = secureContainers.map(\.tag).reduce(.empty, +)
        
        let ciphertextSegment = secureContainers.map(\.ciphertext).reduce(.empty, +)

        return segmentCount + ciphertextSizesSegment + aesKey + hmacKey + tagSegmentTag + tagSegment + ciphertextSegment
    }

}

extension SecureDataByteBuffer {
    
    enum Error: Swift.Error {
        
        case invalidSegmentIndex
        case invalidContainerCount
        
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
    static let macSize = 32

}
