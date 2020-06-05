import CryptoKit
import Foundation

enum SecureDataCodingError: Error {
    
    case invalidIndex
    
}

struct SecureDataCoder {
    
    let itemKeyRange: Range<Int>
    let tagRanges: [Range<Int>]
    let nonceRanges: [Range<Int>]
    let ciphertextRanges: [Range<Int>]
    
    init(from context: DataContext) throws {
        let messageCountRange = Range(lowerBound: 0, count: UnsignedInteger32BitEncodingSize)
        let messageCountBytes = try context.bytes(in: messageCountRange)
        let messageCount = UnsignedInteger32BitDecode(messageCountBytes) as Int

        let ciphertextSizes = try (0 ..< messageCount).map { index in
            let ciphertextSizeLowerBound = messageCountRange.upperBound + index * UnsignedInteger32BitEncodingSize
            let ciphertextSizeRange = Range(lowerBound: ciphertextSizeLowerBound, count: UnsignedInteger32BitEncodingSize)
            let ciphertextSizeBytes = try context.bytes(in: ciphertextSizeRange)
            return UnsignedInteger32BitDecode(ciphertextSizeBytes)
        } as [Int]

        let itemKeyRangeLowerBound = messageCountRange.upperBound + messageCount * UnsignedInteger32BitEncodingSize
        let itemKeyRange = Range(lowerBound: itemKeyRangeLowerBound, count: .wrappedKeySize)

        let tagRanges = (0 ..< messageCount).map { index in
            let tagRangeLowerBound = itemKeyRange.upperBound + index * .tagSize
            return Range(lowerBound: tagRangeLowerBound, count: .tagSize)
        } as [Range<Int>]

        var nonceRangeLowerBound = itemKeyRange.upperBound + messageCount * .tagSize
        let nonceRanges = ciphertextSizes.map { ciphertextSize in
            defer {
                nonceRangeLowerBound += .nonceSize + ciphertextSize
            }
            return Range(lowerBound: nonceRangeLowerBound, count: .nonceSize)
        } as [Range<Int>]
        
        var ciphertextRangeLowerBound = itemKeyRange.upperBound + messageCount * .tagSize + .nonceSize
        let ciphertextRanges = ciphertextSizes.map { ciphertextSize in
            defer {
                ciphertextRangeLowerBound += ciphertextSize + .nonceSize
            }
            return Range(lowerBound: ciphertextRangeLowerBound, count: ciphertextSize)
        } as [Range<Int>]

        self.itemKeyRange = itemKeyRange
        self.tagRanges = tagRanges
        self.nonceRanges = nonceRanges
        self.ciphertextRanges = ciphertextRanges
    }
    
    func decodeItemKey(from context: DataContext) throws -> Data {
        let itemKeyBytes = try context.bytes(in: itemKeyRange)
        return Data(itemKeyBytes)
    }

    func decodeTags(from context: DataContext) throws -> [Data] {
        return try tagRanges.map { tagRange in
            let tagBytes = try context.bytes(in: tagRange)
            return Data(tagBytes)
        }
    }

    func decodeNonce(at index: Int, from context: DataContext) throws -> Data {
        guard nonceRanges.indices.contains(index) else {
            throw SecureDataCodingError.invalidIndex
        }
        
        let nonceRange = nonceRanges[index]
        let nonce = try context.bytes(in: nonceRange)
        return Data(nonce)
    }

    func decodeCiphertext(at index: Int, from context: DataContext) throws -> Data {
        guard ciphertextRanges.indices.contains(index) else {
            throw SecureDataCodingError.invalidIndex
        }

        let ciphertextRange = ciphertextRanges[index]
        let ciphertext = try context.bytes(in: ciphertextRange)
        return Data(ciphertext)
    }
    
}

extension SecureDataCoder {
    
    static func encode(wrappedItemKey: Data, seals: [AES.GCM.SealedBox]) throws -> Data {
        let messageCount = UnsignedInteger32BitEncode(seals.count)
        
        let ciphertextSizes = seals.reduce(.empty) { result, seal in
            let ciphertextSize = UnsignedInteger32BitEncode(seal.ciphertext.count)
            return result + ciphertextSize
        } as Data
        
        let tags = seals.map(\.tag).reduce(.empty, +)
        
        let ciphertextContainers = seals.map { seal in
            return seal.nonce + seal.ciphertext
        }.reduce(.empty, +)

        return messageCount + ciphertextSizes + wrappedItemKey + tags + ciphertextContainers
    }
    
}

private extension Int {

    static let nonceSize = 12
    static let wrappedKeySize = 60
    static let tagSize = 16

}