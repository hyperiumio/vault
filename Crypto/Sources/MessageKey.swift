import CryptoKit
import Foundation

struct MessageKey: Equatable {
    
    let value: SymmetricKey
    
    init() {
        self.value = SymmetricKey(size: .bits256)
    }
    
    init<D>(with data: D) where D: ContiguousBytes {
        self.value = SymmetricKey(data: data)
    }
    
}
