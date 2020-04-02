import Foundation

extension Data {
    
    static let empty = Self()
    
    func transform<T>(_ transform: (Self) throws -> T) rethrows -> T {
        return try transform(self)
    }
    
}

extension Data: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt8) {
        let bytes = [value]
        self = Data(bytes)
    }

}

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
