import CryptoKit
import Foundation

public struct MessageKey {
    
    let value: SymmetricKey
    
    init() {
        self.value = SymmetricKey(size: .bits256)
    }
    
    init<D>(_ data: D) where D: ContiguousBytes {
        self.value = SymmetricKey(data: data)
    }
    
}
