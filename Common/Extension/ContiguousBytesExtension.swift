import Foundation

extension ContiguousBytes {
    
    var bytes: [UInt8] {
        return self.withUnsafeBytes { bytes in
            return [UInt8](bytes)
        }
    }
    
}
