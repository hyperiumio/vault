import Foundation

extension Data: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        let bytes = stride(from: 0, to: value.count, by: 2).map { hexDigestIndex in
            let start = value.index(value.startIndex, offsetBy: hexDigestIndex)
            let end = value.index(start, offsetBy: 2, limitedBy: value.endIndex) ?? value.endIndex
            let hexDigest = value[start ..< end]
            return UInt8(hexDigest, radix: 16)!
        } as [UInt8]

        self = Data(bytes)
    }

}
