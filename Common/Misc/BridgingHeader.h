#import <CommonCrypto/CommonCrypto.h>

int SymmetricKeyWrap(CCWrappingAlgorithm algorithm, const void *iv, const size_t ivLen, const void *kek, size_t kekLen, const void *rawKey, size_t rawKeyLen, void *wrappedKey,size_t *wrappedKeyLen);
int SymmetricKeyUnwrap(CCWrappingAlgorithm algorithm, const void *iv, const size_t ivLen, const void *kek, size_t kekLen, const void *wrappedKey, size_t wrappedKeyLen, void *rawKey, size_t *rawKeyLen);
