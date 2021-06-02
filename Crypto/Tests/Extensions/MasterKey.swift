@testable import Crypto

extension MasterKey: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: UInt8...) {
        self = MasterKey(with: elements)
    }
    
}
