import CommonCrypto
import CryptoKit
import Foundation

func CCSymmetricKeyUnwrap(_ algorithm: CCWrappingAlgorithm, _ iv: UnsafePointer<UInt8>!, _ ivLen: Int, _ kek: UnsafePointer<UInt8>!, _ kekLen: Int, _ wrappedKey: UnsafePointer<UInt8>!, _ wrappedKeyLen: Int, _ rawKey: UnsafeMutablePointer<UInt8>!, _ rawKeyLen: UnsafeMutablePointer<Int>!) -> Int32 {
    CCSymmetricKeyUnwrapArguments.current = CCSymmetricKeyUnwrapArguments(algorithm: algorithm, iv: iv, ivLen: ivLen, kek: kek, kekLen: kekLen, wrappedKey: wrappedKey, wrappedKeyLen: wrappedKeyLen)
    
    switch CCSymmetricKeyUnwrapConfiguration.current! {
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

enum CCSymmetricKeyUnwrapConfiguration {
    
    case pass
    case failure
    case success(key: SymmetricKey)
    
}

extension CCSymmetricKeyUnwrapConfiguration {
    
    static var current: CCSymmetricKeyUnwrapConfiguration?
    
}

struct CCSymmetricKeyUnwrapArguments: Equatable {
    
    let algorithm: CCWrappingAlgorithm
    let iv: Data
    let kek: Data
    let wrappedKey: Data
    
    init(algorithm: CCWrappingAlgorithm, iv: UnsafePointer<UInt8>!, ivLen: Int, kek: UnsafePointer<UInt8>!, kekLen: Int, wrappedKey: UnsafePointer<UInt8>!, wrappedKeyLen: Int) {
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

extension CCSymmetricKeyUnwrapArguments {
    
    static var current: CCSymmetricKeyUnwrapArguments?
    
}
