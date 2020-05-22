#import <stddef.h>

const int Success;

int DerivedKey(const void *password, size_t passwordLen, const void *salt, size_t saltLen, unsigned rounds, void *derivedKey, size_t derivedKeyLen);
