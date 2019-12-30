#import <CommonCrypto/CommonCrypto.h>

int SymmetricKeyWrap(const void *kek, size_t kekLen, const void *rawKey, size_t rawKeyLen, void *wrappedKey, size_t wrappedKeyLen);
int SymmetricKeyUnwrap(const void *kek, size_t kekLen, const void *wrappedKey, size_t wrappedKeyLen, void *rawKey, size_t rawKeyLen);
size_t SymmetricWrappedSize(size_t rawKeyLen);
size_t SymmetricUnwrappedSize(size_t wrappedKeyLen);
