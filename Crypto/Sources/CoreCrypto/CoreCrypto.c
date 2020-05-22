#include <CommonCrypto/CommonCrypto.h>
#include "CoreCrypto.h"

const int CryptoSuccess = kCCSuccess;

int DerivedKey(const void *password, size_t passwordLen, const void *salt, size_t saltLen, unsigned rounds, void *derivedKey, size_t derivedKeyLen) {
    return CCKeyDerivationPBKDF(kCCPBKDF2, password, passwordLen, salt, saltLen, kCCPRFHmacAlgSHA512, rounds, derivedKey, derivedKeyLen);
}
