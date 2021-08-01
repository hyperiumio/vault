import CommonCrypto
import CryptoKit
import Foundation

struct DerivedKey: Equatable {
    
    let value: SymmetricKey
    
    init<D>(with data: D) where D: ContiguousBytes {
        self.value = SymmetricKey(data: data)
    }
    
    init(from password: String, with publicArguments: PublicArguments) throws {
        self.value = try PBKDF2(salt: publicArguments.salt, rounds: publicArguments.rounds, password: password)
    }
    
}

extension DerivedKey {
    
    struct PublicArguments {
        
        let salt: Data
        let rounds: UInt32
        
        init(configuration: Configuration = .production) throws {
            var salt = Data(repeating: 0, count: .saltSize)
            try salt.withUnsafeMutableBytes { buffer in
                let status = configuration.rng(buffer.baseAddress, buffer.count)
                guard status == kCCSuccess else {
                    throw CryptoError.randomNumberGenerationFailed
                }
            }
            
            self.salt = salt
            self.rounds = .defaultRounds
        }
        
        init(from container: Data) throws {
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
        
        func container() -> Data {
            salt + UInt32Encode(rounds)
        }
        
    }
    
    struct Configuration {
        
        let rng: (_ bytes: UnsafeMutableRawPointer?, _ count: Int) -> CCRNGStatus
        
        static var production: Self {
            Self(rng: CCRandomGenerateBytes)
        }
        
    }
    
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

    static var saltSize: Self { 32 }
    static var keySize: Self { 32 }

}

private extension UInt32 {

    static var defaultRounds: Self { 524288 }

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
