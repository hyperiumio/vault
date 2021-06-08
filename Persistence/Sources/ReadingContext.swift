import Foundation

public struct ReadingContext {
    
    public let itemLocator: StoreItemLocator
    
    init(_ itemLocator: StoreItemLocator) {
        self.itemLocator = itemLocator
    }
    
    public func bytes(in range: Range<Int>) throws -> Data {
        let fileHandle = try FileHandle(forReadingFrom: itemLocator.url)
        
        guard let fileOffset = UInt64(exactly: range.startIndex) else {
            throw PersistenceError.invalidByteRange
        }
        
        try fileHandle.seek(toOffset: fileOffset)
        guard let data = try? fileHandle.read(upToCount: range.count) else {
            throw PersistenceError.dataNotAvailable
        }
        
        return data
    }
    
}

#warning("Workaround")
extension FileHandle {
    
    public func read(upToCount count: Int) throws -> Data? {
        readData(ofLength: count)
    }
    
}
