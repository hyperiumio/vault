import CryptoKit

extension AES.GCM.SealedBox: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: UInt8...) {
        self = try! AES.GCM.SealedBox(combined: elements)
    }
    
}

extension AES.GCM.Nonce: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: UInt8...) {
        self = try! AES.GCM.Nonce(data: elements)
    }
    
}
