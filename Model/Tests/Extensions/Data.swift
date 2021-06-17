import Foundation

extension Data: ExpressibleByStringInterpolation {
    
    public init(stringLiteral value: String) {
        self = Data(value.utf8)
    }
    
}

extension Data: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: UInt8...) {
        self = Data(elements)
    }
    
}
