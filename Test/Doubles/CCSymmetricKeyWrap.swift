import CommonCrypto
import CryptoKit
import Foundation

func CCSymmetricKeyWrap(_ algorithm: CCWrappingAlgorithm, _ iv: UnsafePointer<UInt8>!, _ ivLen: Int, _ kek: UnsafePointer<UInt8>!, _ kekLen: Int, _ rawKey: UnsafePointer<UInt8>!, _ rawKeyLen: Int, _ wrappedKey: UnsafeMutablePointer<UInt8>!, _ wrappedKeyLen: UnsafeMutablePointer<Int>!) -> Int32 {
    CCSymmetricKeyWrapArguments.current = CCSymmetricKeyWrapArguments(algorithm: algorithm, iv: iv, ivLen: ivLen, kek: kek, kekLen: kekLen, rawKey: rawKey, rawKeyLen: rawKeyLen, wrappedKey: wrappedKey, wrappedKeyLen: wrappedKeyLen)
    
    switch CCSymmetricKeyWrapConfiguration.current! {
    case .pass:
        return Int32(kCCSuccess)
    case .failure:
        return Int32(kCCUnspecifiedError)
    case .success(let bytes):
        bytes.copyBytes(to: wrappedKey, count: wrappedKeyLen.pointee)
        return Int32(kCCSuccess)
    }
    
}

enum CCSymmetricKeyWrapConfiguration {
    
    case pass
    case failure
    case success(bytes: Data)
    
}

extension CCSymmetricKeyWrapConfiguration {
    
    static var current: CCSymmetricKeyWrapConfiguration?
    
}

struct CCSymmetricKeyWrapArguments: Equatable {
    
    let algorithm: CCWrappingAlgorithm
    let iv: Data
    let kek: Data
    let rawKey: Data
    
    init(algorithm: CCWrappingAlgorithm, iv: UnsafePointer<UInt8>, ivLen: Int, kek: UnsafePointer<UInt8>, kekLen: Int, rawKey: UnsafePointer<UInt8>, rawKeyLen: Int, wrappedKey: UnsafePointer<UInt8>, wrappedKeyLen: UnsafePointer<Int>) {
        self.algorithm = algorithm
        self.iv = Data(bytes: iv, count: ivLen)
        self.kek = Data(bytes: kek, count: kekLen)
        self.rawKey = Data(bytes: rawKey, count: rawKeyLen)
    }
    
    init(rawKey: SymmetricKey, kek: SymmetricKey) {
        self.algorithm = CCWrappingAlgorithm(kCCWRAPAES)
        self.iv = Data(bytes: CCrfc3394_iv, count: CCrfc3394_ivLen)
        self.kek = kek.withUnsafeBytes { bytes in
            return Data(bytes)
        }
        self.rawKey = rawKey.withUnsafeBytes { bytes in
            return Data(bytes)
        }
    }
}

extension CCSymmetricKeyWrapArguments {
    
    static var current: CCSymmetricKeyWrapArguments?
    
}
