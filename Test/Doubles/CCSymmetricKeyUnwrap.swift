import CommonCrypto
import CryptoKit
import Foundation

func SymmetricKeyUnwrap(_ algorithm: CCWrappingAlgorithm, _ iv: UnsafeRawPointer!, _ ivLen: Int, _ kek: UnsafeRawPointer!, _ kekLen: Int, _ wrappedKey: UnsafeRawPointer!, _ wrappedKeyLen: Int, _ rawKey: UnsafeMutablePointer<UInt8>!, _ rawKeyLen: UnsafeMutablePointer<Int>!) -> Int32 {
    SymmetricKeyUnwrapArguments.current = SymmetricKeyUnwrapArguments(algorithm: algorithm, iv: iv, ivLen: ivLen, kek: kek, kekLen: kekLen, wrappedKey: wrappedKey, wrappedKeyLen: wrappedKeyLen)
    
    switch SymmetricKeyUnwrapConfiguration.current! {
    case .pass:
        return Int32(kCCSuccess)
    case .failure:
        return Int32(kCCUnspecifiedError)
    case .success(let key):
        key.withUnsafeBytes { key in
            Data(key).copyBytes(to: rawKey, count: rawKeyLen.pointee)
        }
        return Int32(kCCSuccess)
    }
}

enum SymmetricKeyUnwrapConfiguration {
    
    case pass
    case failure
    case success(key: SymmetricKey)
    
}

extension SymmetricKeyUnwrapConfiguration {
    
    static var current: SymmetricKeyUnwrapConfiguration?
    
}

struct SymmetricKeyUnwrapArguments: Equatable {
    
    let algorithm: CCWrappingAlgorithm
    let iv: Data
    let kek: Data
    let wrappedKey: Data
    
    init(algorithm: CCWrappingAlgorithm, iv: UnsafeRawPointer!, ivLen: Int, kek: UnsafeRawPointer!, kekLen: Int, wrappedKey: UnsafeRawPointer!, wrappedKeyLen: Int) {
        self.algorithm = algorithm
        self.iv = Data(bytes: iv, count: ivLen)
        self.kek = Data(bytes: kek, count: kekLen)
        self.wrappedKey = Data(bytes: wrappedKey, count: wrappedKeyLen)
    }

    init(wrappedKey: Data, kek: SymmetricKey) {
        self.algorithm = CCWrappingAlgorithm(kCCWRAPAES)
        self.iv = Data(bytes: CCrfc3394_iv, count: CCrfc3394_ivLen)
        self.kek = kek.withUnsafeBytes { bytes in
            return Data(bytes)
        }
        self.wrappedKey = wrappedKey
    }
    
}

extension SymmetricKeyUnwrapArguments {
    
    static var current: SymmetricKeyUnwrapArguments?
    
}
