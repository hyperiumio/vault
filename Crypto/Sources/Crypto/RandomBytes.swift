import CommonCrypto
import Foundation

enum RandomBytesError: Error {
    
    case randomNumberGeneratorFailure
    
}

struct RandomNumberGenerator {
    
    private let allocate: Allocate
    private let generate: Generate
    
    init(allocate: @escaping Allocate = UnsafeMutableRawPointer.allocate, generate: @escaping Generate = CCRandomGenerateBytes) {
        self.allocate = allocate
        self.generate = generate
    }
    
    func generate(count: Int) throws -> Data {
        let bytes = allocate(count, MemoryLayout<UInt8>.alignment)
        
        let status = generate(bytes, count)
        guard status == kCCSuccess else {
            throw RandomBytesError.randomNumberGeneratorFailure
        }
       
        return Data(bytesNoCopy: bytes, count: count, deallocator: .free)
    }
    
}

extension RandomNumberGenerator {
    
    typealias Allocate = (_ byteCount: Int, _ alignment: Int) -> UnsafeMutableRawPointer
    typealias Generate = (_ bytes: UnsafeMutableRawPointer?, _ count: Int) -> Int32
    
}
