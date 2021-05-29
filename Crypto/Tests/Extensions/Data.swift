import Foundation

extension Data: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: UInt8...) {
        self = Data(elements)
    }
    
}
