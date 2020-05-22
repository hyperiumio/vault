@testable import Crypto

class WritableBufferMock: WritableBuffer {
    
    private let pointer: UnsafeMutableRawBufferPointer
    private var deallocCallCount = 0
    
    init(byteCount: Int, repeatingValue: UInt8) {
        let pointer = UnsafeMutableRawBufferPointer.allocate(byteCount: byteCount, alignment: MemoryLayout<UInt8>.alignment)
        for index in 0 ..< pointer.count {
            pointer[index] = repeatingValue
        }
        
        self.pointer = pointer
        
    }
    
    deinit {
        pointer.deallocate()
    }
    
    var didCallDealloc: Bool {
        return deallocCallCount == 1
    }
    
    var didOverrideBytes: Bool {
        return pointer.allSatisfy { byte in
            return byte == 0
        }
    }
    
    var indices: Range<Int> {
        return pointer.indices
    }
    
    var count: Int {
        return pointer.count
    }
    
    var baseAddress: UnsafeMutableRawPointer? {
        return pointer.baseAddress
    }
    
    var continousBytes: UnsafeMutableRawBufferPointer {
        return pointer
    }
    
    subscript(i: Int) -> UnsafeMutableRawBufferPointer.Element {
        get {
            return pointer[i]
        }
        set(newValue) {
            pointer[i] = newValue
        }
    }
    
    func deallocate() {
        deallocCallCount += 1
    }
    
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        try pointer.withUnsafeBytes(body)
    }
    
}
