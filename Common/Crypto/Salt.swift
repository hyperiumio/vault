import Foundation

enum SaltError: Error {
    
    case randomNumberGeneratorFailure
    
}

struct Salt {
    
    private let bytes: Data
    
    init(size: Int, rng: RNG = RandomBytes) throws {
        var bytes = Data(count: size)
        let status = bytes.withUnsafeMutableBytes { buffer in
            return rng(buffer.baseAddress!, size)
        }
        guard status == CryptoSuccess else {
            throw SaltError.randomNumberGeneratorFailure
        }
        
        self.bytes = bytes
    }
    
    init(data: Data) {
        self.bytes = data
    }
    
}

extension Salt {
    
    typealias RNG = (UnsafeMutableRawPointer, Int) -> Int32
    
}

extension Salt: ContiguousBytes {
    
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        return try bytes.withUnsafeBytes(body)
    }
    
}
