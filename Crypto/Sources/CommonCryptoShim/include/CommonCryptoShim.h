#include <CommonCrypto/CommonCrypto.h>

int shim_CCKeyDerivationPBKDF(CCPBKDFAlgorithm algorithm, const void *password, size_t passwordLen, const void *salt, size_t saltLen, CCPseudoRandomAlgorithm prf, unsigned rounds, void *derivedKey, size_t derivedKeyLen);
 
