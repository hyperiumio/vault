var ManagedMemoryAllocator = UnsafeMutableRawBufferPointer.allocate as (Int, Int) -> WritableBuffer

func ManagedMemory<Result>(byteCount: Int, body: (UnsafeMutableRawBufferPointer) throws -> Result) rethrows -> Result  {
    let alignment = MemoryLayout<UInt8>.alignment
    let buffer = ManagedMemoryAllocator(byteCount, alignment)
    defer {
        for index in buffer.indices {
            buffer[index] = 0
        }
        buffer.deallocate()
    }
    
    return try body(buffer.bytes)
}

protocol WritableBuffer {
    
    var indices: Range<Int> { get }
    var bytes: UnsafeMutableRawBufferPointer { get }
    
    subscript(i: Int) -> UnsafeMutableRawBufferPointer.Element { get nonmutating set }

    func deallocate()
    
}

extension UnsafeMutableRawBufferPointer: WritableBuffer {
    
    var bytes: UnsafeMutableRawBufferPointer {
        return self
    }
    
}
