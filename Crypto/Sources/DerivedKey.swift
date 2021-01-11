import CommonCrypto
import CryptoKit
import Foundation

public struct DerivedKey {
    
    let value: SymmetricKey
    
    public init<D>(_ data: D) where D: ContiguousBytes {
        self.value = SymmetricKey(data: data)
    }
    
    public init(from password: String, with publicArguments: PublicArguments) throws {
        self.value = try PBKDF2(salt: publicArguments.salt, rounds: publicArguments.rounds, password: password)
    }
    
}

extension DerivedKey: ContiguousBytes {
    
    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        try value.withUnsafeBytes(body)
    }
    
}

extension DerivedKey {
    
    public struct PublicArguments {
        
        let salt: Data
        let rounds: UInt32
        
        public init(rng: RNG = CCRandomGenerateBytes) throws {
            var salt = Data(repeating: 0, count: .saltSize)
            try salt.withUnsafeMutableBytes { buffer in
                let status = rng(buffer.baseAddress, buffer.count)
                guard status == kCCSuccess else {
                    throw CryptoError.randomNumberGenerationFailed
                }
            }
            
            self.salt = salt
            self.rounds = .defaultRounds
        }
        
        public init(from container: Data) throws {
            guard container.count == .saltSize + UInt32CodingSize else {
                throw CryptoError.invalidDataSize
            }
            
            let saltRange = Range(container.startIndex, count: .saltSize)
            let roundsRange = Range(saltRange.upperBound, count: UInt32CodingSize)
            
            let salt = container[saltRange]
            let roundsData = container[roundsRange]
            let rounds = try UInt32Decode(roundsData)
            
            self.salt = salt
            self.rounds = rounds
        }
        
        public func container() -> Data {
            salt + UInt32Encode(rounds)
        }
        
    }
    
}

extension DerivedKey.PublicArguments {
    
    public typealias RNG = (_ bytes: UnsafeMutableRawPointer?, _ count: Int) -> CCRNGStatus
    
}

private func PBKDF2(salt: Data, rounds: UInt32, password: String) throws -> SymmetricKey {
    let salt = Array(salt)
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: .keySize)
    buffer.initialize(repeating: 0, count: .keySize)
    defer {
        buffer.assign(repeating: 0, count: .keySize)
        buffer.deinitialize(count: .keySize)
        buffer.deallocate()
    }
    
    let status = CCKeyDerivationPBKDF(.PBKDF2, password, password.count, salt, salt.count, .PRFHmacAlgSHA512, rounds, buffer, .keySize)
    guard status == kCCSuccess else {
        throw CryptoError.keyDerivationFailed
    }
    
    let key = UnsafeBufferPointer(start: buffer, count: .keySize)
    return SymmetricKey(data: key)
}

private extension Int {

    static let saltSize = 32
    static let keySize = 32

}

private extension UInt32 {

    static let defaultRounds = 524288 as Self

}

private extension Range where Bound == Int {
    
    init(_ lowerBound: Bound, count: Int) {
        self = lowerBound ..< lowerBound + count
    }
    
}

private extension CCPBKDFAlgorithm {
    
    static var PBKDF2: Self {
        Self(kCCPBKDF2)
    }
    
}

private extension CCPseudoRandomAlgorithm {
    
    static var PRFHmacAlgSHA512: Self {
        Self(kCCPRFHmacAlgSHA512)
    }
    
}
