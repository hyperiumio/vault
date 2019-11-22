import CommonCrypto
import CryptoKit
import Foundation

func SymmetricKeyWrap(_ algorithm: CCWrappingAlgorithm, _ iv: UnsafeRawPointer!, _ ivLen: Int, _ kek: UnsafeRawPointer!, _ kekLen: Int, _ rawKey: UnsafeRawPointer!, _ rawKeyLen: Int, _ wrappedKey: UnsafeMutablePointer<UInt8>!, _ wrappedKeyLen: UnsafeMutablePointer<Int>!) -> Int32 {
    SymmetricKeyWrapArguments.current = SymmetricKeyWrapArguments(algorithm: algorithm, iv: iv, ivLen: ivLen, kek: kek, kekLen: kekLen, rawKey: rawKey, rawKeyLen: rawKeyLen, wrappedKey: wrappedKey, wrappedKeyLen: wrappedKeyLen)
    
    switch SymmetricKeyWrapConfiguration.current! {
    case .pass:
        return Int32(kCCSuccess)
    case .failure:
        return Int32(kCCUnspecifiedError)
    case .success(let bytes):
        bytes.copyBytes(to: wrappedKey, count: wrappedKeyLen.pointee)
        return Int32(kCCSuccess)
    }
    
}

enum SymmetricKeyWrapConfiguration {
    
    case pass
    case failure
    case success(bytes: Data)
    
}

extension SymmetricKeyWrapConfiguration {
    
    static var current: SymmetricKeyWrapConfiguration?
    
}

struct SymmetricKeyWrapArguments: Equatable {
    
    let algorithm: CCWrappingAlgorithm
    let iv: Data
    let kek: Data
    let rawKey: Data
    
    init(algorithm: CCWrappingAlgorithm, iv: UnsafeRawPointer, ivLen: Int, kek: UnsafeRawPointer, kekLen: Int, rawKey: UnsafeRawPointer, rawKeyLen: Int, wrappedKey: UnsafeRawPointer, wrappedKeyLen: UnsafePointer<Int>) {
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

extension SymmetricKeyWrapArguments {
    
    static var current: SymmetricKeyWrapArguments?
    
}
