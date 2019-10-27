import CommonCrypto
import Foundation

struct Salt {
    
    private let bytes: Data
    
    init(size: Int) throws {
        var bytes = Data(count: size)
        let status = bytes.withUnsafeMutableBytes { buffer in
            return CCRandomGenerateBytes(buffer.baseAddress, size)
        }
        guard status == kCCSuccess else {
            throw SaltError.randomNumberGeneratorFailure
        }
        
        self.bytes = bytes
    }
    
}

enum SaltError: Error {
    
    case randomNumberGeneratorFailure
    
}

extension Salt: ContiguousBytes {
    
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        return try bytes.withUnsafeBytes(body)
    }
    
}
