extension UnsafeMutableBufferPointer {
    
    func deinitialize() {
        self.baseAddress?.deinitialize(count: self.count)
    }
    
}
