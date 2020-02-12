import Foundation

extension ContiguousBytes {
    
    var bytes: Data {
        return self.withUnsafeBytes { bytes in
            return Data(bytes)
        }
    }
    
}
