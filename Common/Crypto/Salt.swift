import CommonCrypto
import Foundation

struct Salt {
    
    private let bytes: Data
    
    init(size: Int, rng: RNG = CCRandomGenerateBytes) throws {
        var bytes = Data(count: size)
        let status = bytes.withUnsafeMutableBytes { buffer in
            return rng(buffer.baseAddress, size)
        }
        guard status == kCCSuccess else {
            throw Error.randomNumberGeneratorFailure
        }
        
        self.bytes = bytes
    }
    
}

extension Salt {
    
    enum Error: Swift.Error {
        
        case randomNumberGeneratorFailure
        
    }
    
    typealias RNG = (UnsafeMutableRawPointer?, Int) -> CCRNGStatus
    
}

extension Salt: ContiguousBytes {
    
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        return try bytes.withUnsafeBytes(body)
    }
    
}
