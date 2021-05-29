import CryptoKit

extension SymmetricKey: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: UInt8...) {
        self = SymmetricKey(data: elements)
    }
    
}
