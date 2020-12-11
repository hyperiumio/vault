import XCTest
@testable import Crypto

/*
class ManagedMemoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        ManagedMemoryAllocator = { _, _ in fatalError() }
    }
    
    override func tearDown() {
        ManagedMemoryAllocator = UnsafeMutableRawBufferPointer.allocate
        
        super.tearDown()
    }
    
    func testMemoryAllocationArguments() {
        let expectedByteCount = 8
        
        ManagedMemoryAllocator = { count, alignment in
            XCTAssertEqual(count, expectedByteCount)
            XCTAssertEqual(alignment, MemoryLayout<UInt8>.alignment)
            
            return UnsafeMutableRawBufferPointer.allocate(byteCount: count, alignment: alignment)
        }
        
        ManagedMemory(byteCount: expectedByteCount) { buffer in }
    }
    
    func testMemoryBodyExecution() {
        let byteCount = 8
        let expectedBuffer = UnsafeMutableRawBufferPointer.allocate(byteCount: byteCount, alignment: MemoryLayout<UInt8>.alignment)
        
        ManagedMemoryAllocator = { count, alignment in expectedBuffer }
        
        ManagedMemory(byteCount: byteCount) { buffer in
            XCTAssertEqual(buffer.baseAddress, expectedBuffer.baseAddress)
            XCTAssertEqual(buffer.count, expectedBuffer.count)
        }
    }
    
    func testMemoryCleanup() {
        let byteCount = 8
        let managedBuffer = WritableBufferMock(byteCount: byteCount, repeatingValue: 01)
        
        ManagedMemoryAllocator = { count, alignment in managedBuffer }
        
        ManagedMemory(byteCount: byteCount) { buffer in
            for index in buffer.indices {
                buffer[index] = 02
            }
        }
        
        XCTAssert(managedBuffer.didOverrideBytes)
        XCTAssert(managedBuffer.didDeallocate)
    }
    
}

private class WritableBufferMock: WritableBuffer {
    
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
    
    var didDeallocate: Bool {
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
    
    var bytes: UnsafeMutableRawBufferPointer {
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
    
}
*/
