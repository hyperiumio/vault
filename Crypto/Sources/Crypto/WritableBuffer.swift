import Foundation

protocol WritableBuffer: ContiguousBytes {
    
    var indices: Range<Int> { get }
    var count: Int { get }
    var baseAddress: UnsafeMutableRawPointer? { get }
    var continousBytes: UnsafeMutableRawBufferPointer { get }
    
    subscript(i: Int) -> UnsafeMutableRawBufferPointer.Element { get nonmutating set }

    func deallocate()
    
}

extension UnsafeMutableRawBufferPointer: WritableBuffer {
    
    var continousBytes: UnsafeMutableRawBufferPointer {
        return self
    }
    
}
