import CommonCrypto
import CryptoKit
import Foundation

func AESKeyWrap(_ key: SymmetricKey, using keyEncryptionKey: SymmetricKey) throws -> Data {
    var bufferSize = AESKeyWrappedSize(unwrappedSize: key.byteCount)
    let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bufferSize)
    buffer.initialize(repeating: 0)
    defer {
        buffer.assign(repeating: 0)
        buffer.deinitialize()
        buffer.deallocate()
    }
    
    let status = key.withUnsafeBytesCopy { key in
        return keyEncryptionKey.withUnsafeBytesCopy { keyEncryptionKey in
            return CCSymmetricKeyWrap(.rfc3394, CCrfc3394_iv, CCrfc3394_ivLen, keyEncryptionKey.baseAddress, keyEncryptionKey.count, key.baseAddress, key.count, buffer.baseAddress, &bufferSize)
        }
    }
    guard status == kCCSuccess else {
        throw AESKeyWrapError.keyWrapFailure
    }
    
    return Data(buffer)
}

enum AESKeyWrapError: Error {
    
    case keyWrapFailure
    
}

func AESKeyUnwrap(_ keyBytes: Data, using keyEncryptionKey: SymmetricKey) throws -> SymmetricKey {
    var bufferSize = AESKeyUnwrappedSize(wrappedSize: keyBytes.count)
    let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: bufferSize)
    buffer.initialize(repeating: 0)
    defer {
        buffer.assign(repeating: 0)
        buffer.deinitialize()
        buffer.deallocate()
    }
    
    let status = keyBytes.withUnsafeBytesCopy { key in
        return keyEncryptionKey.withUnsafeBytesCopy { keyEncryptionKey in
            return CCSymmetricKeyUnwrap(.rfc3394, CCrfc3394_iv, CCrfc3394_ivLen, keyEncryptionKey.baseAddress, keyEncryptionKey.count, key.baseAddress, key.count, buffer.baseAddress, &bufferSize)
        }
    }
    guard status == kCCSuccess else {
        throw AESKeyUnwrapError.keyUnwrapFailure
    }
    
    return SymmetricKey(data: buffer)
}

enum AESKeyUnwrapError: Error {
    
    case keyUnwrapFailure
    
}

func AESKeyWrappedSize(unwrappedSize: Int) -> Int {
    return CCSymmetricWrappedSize(.rfc3394, unwrappedSize)
}

func AESKeyUnwrappedSize(wrappedSize: Int) -> Int {
    return CCSymmetricUnwrappedSize(.rfc3394, wrappedSize)
}

private extension CCWrappingAlgorithm {
    
    static let rfc3394 = CCWrappingAlgorithm(kCCWRAPAES)
    
}

private extension SymmetricKey {
    
    var byteCount: Int {
        return self.withUnsafeBytes { bytes in
            return bytes.count
        }
    }
}

private extension UnsafeMutableBufferPointer {
    
    func deinitialize() {
        self.baseAddress?.deinitialize(count: self.count)
    }
    
}

private extension ContiguousBytes {
    
    func withUnsafeBytesCopy<R>(_ body: (UnsafeBufferPointer<UInt8>) throws -> R) rethrows -> R {
        return try self.withUnsafeBytes { rawBuffer in
            let byteBuffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: rawBuffer.count)
            byteBuffer.initialize(repeating: 0)
            defer {
                byteBuffer.assign(repeating: 0)
                byteBuffer.deinitialize()
                byteBuffer.deallocate()
            }
            
            for index in 0 ..< rawBuffer.count {
                byteBuffer[index] = rawBuffer.load(fromByteOffset: index, as: UInt8.self)
            }
            
            let readOnlyByteBuffer = UnsafeBufferPointer(byteBuffer)
            return try body(readOnlyByteBuffer)
        }
    }
    
}
