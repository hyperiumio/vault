import CryptoKit
import Foundation

enum SecureDataCodingError: Error {
    
    case invalidIndex
    
}

struct SecureDataDecodingToken {
    
    let itemKeyRange: Range<Int>
    let tagRanges: [Range<Int>]
    let nonceRanges: [Range<Int>]
    let ciphertextRanges: [Range<Int>]
    
    init(from context: DataContext) throws {
        let messageCountRange = Range(lowerBound: 0, count: .unsignedInteger32BitSize)
        let messageCountBytes = try context.bytes(in: messageCountRange)
        let messageCount = try UnsignedInteger32BitDecode(messageCountBytes)

        let ciphertextSizes = try (0 ..< messageCount).map { index in
            let ciphertextSizeLowerBound = messageCountRange.upperBound + index * .unsignedInteger32BitSize
            let ciphertextSizeRange = Range(lowerBound: ciphertextSizeLowerBound, count: .unsignedInteger32BitSize)
            let ciphertextSizeBytes = try context.bytes(in: ciphertextSizeRange)
            return try UnsignedInteger32BitDecode(ciphertextSizeBytes)
        } as [Int]

        let itemKeyRangeLowerBound = messageCountRange.upperBound + messageCount * .unsignedInteger32BitSize
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
    
}

func SecureDataEncode(wrappedItemKey: Data, seals: [AES.GCM.SealedBox]) throws -> Data {
    let messageCount = try UnsignedInteger32BitEncode(seals.count)
    
    let ciphertextSizes = try seals.reduce(.empty) { result, seal in
        let ciphertextSize = try UnsignedInteger32BitEncode(seal.ciphertext.count)
        return result + ciphertextSize
    } as Data
    
    let tags = seals.map(\.tag).reduce(.empty, +)
    
    let ciphertextContainers = seals.map { seal in
        return seal.nonce + seal.ciphertext
    }.reduce(.empty, +)

    return messageCount + ciphertextSizes + wrappedItemKey + tags + ciphertextContainers
}

func SecureDataDecodeItemKey(token: SecureDataDecodingToken, context: DataContext) throws -> Data {
    let itemKeyBytes = try context.bytes(in: token.itemKeyRange)
    return Data(itemKeyBytes)
}

func SecureDataDecodeTags(token: SecureDataDecodingToken, context: DataContext) throws -> [Data] {
    return try token.tagRanges.map { tagRange in
        let tagBytes = try context.bytes(in: tagRange)
        return Data(tagBytes)
    }
}

func SecureDataDecodeNonce(index: Int, token: SecureDataDecodingToken, context: DataContext) throws -> Data {
    guard token.nonceRanges.indices.contains(index) else {
        throw SecureDataCodingError.invalidIndex
    }
    
    let nonceRange = token.nonceRanges[index]
    let nonce = try context.bytes(in: nonceRange)
    return Data(nonce)
}

func SecureDataDecodeCiphertext(index: Int, token: SecureDataDecodingToken, context: DataContext) throws -> Data {
    guard token.ciphertextRanges.indices.contains(index) else {
        throw SecureDataCodingError.invalidIndex
    }

    let ciphertextRange = token.ciphertextRanges[index]
    let ciphertext = try context.bytes(in: ciphertextRange)
    return Data(ciphertext)
}

private extension Int {

    static let unsignedInteger32BitSize = 4
    static let nonceSize = 12
    static let wrappedKeySize = 60
    static let tagSize = 16

}
