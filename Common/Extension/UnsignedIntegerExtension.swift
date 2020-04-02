import Foundation

extension UnsignedInteger {

    var bytes: Data {
        return withUnsafeBytes(of: self) { bytes in
            return Data(bytes)
        }
    }
    
}
