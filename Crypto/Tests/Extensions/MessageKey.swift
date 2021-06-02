@testable import Crypto

extension MessageKey: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: UInt8...) {
        self = MessageKey(with: elements)
    }
    
}
