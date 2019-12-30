#import <CommonCrypto/CommonCrypto.h>

int SymmetricKeyWrap(const void *kek, size_t kekLen, const void *rawKey, size_t rawKeyLen, void *wrappedKey, size_t wrappedKeyLen) {
    return CCSymmetricKeyWrap(kCCWRAPAES, CCrfc3394_iv, CCrfc3394_ivLen, kek, kekLen, rawKey, rawKeyLen, wrappedKey, &wrappedKeyLen);
}

int SymmetricKeyUnwrap(const void *kek, size_t kekLen, const void *wrappedKey, size_t wrappedKeyLen, void *rawKey, size_t rawKeyLen) {
    return CCSymmetricKeyUnwrap(kCCWRAPAES, CCrfc3394_iv, CCrfc3394_ivLen, kek, kekLen, wrappedKey, wrappedKeyLen, rawKey, &rawKeyLen);
}

size_t SymmetricWrappedSize(size_t rawKeyLen) {
    return CCSymmetricWrappedSize(kCCWRAPAES, rawKeyLen);
}

size_t SymmetricUnwrappedSize(size_t wrappedKeyLen) {
    return CCSymmetricUnwrappedSize(kCCWRAPAES, wrappedKeyLen);
}
