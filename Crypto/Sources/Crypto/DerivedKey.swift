import CommonCrypto
import CoreCrypto
import CryptoKit
import Foundation

public struct DerivedKey {
    
    let value: SymmetricKey
    
    init(_ data: Data) {
        self.value = SymmetricKey(data: data)
    }
    
    init(_ value: SymmetricKey) {
        self.value = value
    }
    
    public init(container: Data, password: String) throws {
        guard container.count == .saltSize + UnsignedInteger32BitEncodingSize else {
            throw CryptoError.invalidDataSize
        }
        
        let saltRange = Range(lowerBound: container.startIndex, count: .saltSize)
        let roundsRange = Range(lowerBound: saltRange.upperBound, count: UnsignedInteger32BitEncodingSize)
        
        let salt = container[saltRange]
        let roundsData = container[roundsRange]
        let rounds = UnsignedInteger32BitDecode(roundsData) as UInt32
        
        self.value = try PBKDF2(salt: salt, rounds: rounds, keySize: .keySize, password: password)
    }
    
    public static func derive(from password: String) throws -> (container: Data, key: Self) {
        var salt = Data(repeating: 0, count: .saltSize)
        
        let status = salt.withUnsafeMutableBytes { buffer in
            CCRandomGenerateBytes(buffer.baseAddress, buffer.count)
        }
        guard status == kCCSuccess else {
            throw CryptoError.rngFailure
        }
        
        let container = salt + UnsignedInteger32BitEncode(.keyDerivationRounds)
        let key = try PBKDF2(salt: salt, rounds: .keyDerivationRounds, keySize: .keySize, password: password)
        
        return (container, DerivedKey(key))
    }
    
}

public extension DerivedKey {
    
    struct Container {
        
        let salt: Data
        let rounds: UInt32
        
        init() throws {
            var salt = Data(repeating: 0, count: .saltSize)
            
            let status = salt.withUnsafeMutableBytes { buffer in
                CCRandomGenerateBytes(buffer.baseAddress, buffer.count)
            }
            guard status == kCCSuccess else {
                throw CryptoError.rngFailure
            }
            
            self.salt = salt
            self.rounds = .keyDerivationRounds
        }
        
        init(from data: Data) throws {
            guard data.count == .saltSize + UnsignedInteger32BitEncodingSize else {
                throw CryptoError.invalidDataSize
            }
            
            let saltRange = Range(lowerBound: data.startIndex, count: .saltSize)
            let roundsRange = Range(lowerBound: saltRange.upperBound, count: UnsignedInteger32BitEncodingSize)
            
            let salt = data[saltRange]
            let roundsData = data[roundsRange]
            
            self.salt = salt
            self.rounds = UnsignedInteger32BitDecode(roundsData)
        }
        
        public func encoded() throws -> Data {
            salt + UnsignedInteger32BitEncode(rounds)
        }
        
    }
    
}

private func PBKDF2(salt: Data, rounds: UInt32, keySize: Int, password: String) throws -> SymmetricKey {
    let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: keySize, alignment: MemoryLayout<UInt8>.alignment)
    defer {
        for index in buffer.indices {
            buffer[index] = 0
        }
        buffer.deallocate()
    }
    
    let status = salt.withUnsafeBytes { salt in
        CoreCrypto.PBKDF2(password, password.count, salt.baseAddress, salt.count, rounds, buffer.baseAddress, buffer.count)
    }
    guard status == CoreCrypto.Success else {
        throw CryptoError.keyDerivationFailure
    }
    
    return SymmetricKey(data: buffer)
}

private extension Int {

    static let saltSize = 32
    static let keySize = 32

}

private extension UInt32 {
    
    static let keyDerivationRounds: Self = 524288
    
}
