extension UnsafeMutableRawBufferPointer {
    
    static func managedByteContext<Result>(byteCount: Int, _ body: (UnsafeMutableRawBufferPointer) throws -> Result) rethrows -> Result {
        let bytes = UnsafeMutableRawBufferPointer.allocate(byteCount: byteCount, alignment: 1)
        defer {
            for index in bytes.indices {
                bytes[index] = 0
            }
            bytes.deallocate()
        }
        
        return try body(bytes)
    }
    
}
