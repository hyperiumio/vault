import Foundation

public struct ReadingContext {
    
    let url: URL
    
    public var bytes: Data {
        get throws {
            try Data(contentsOf: url)
        }
    }
    
    public func bytes(in range: Range<Int>) throws -> Data {
        let fileHandle = try FileHandle(forReadingFrom: url)
        
        guard let fileOffset = UInt64(exactly: range.startIndex) else {
            throw StoreError.invalidByteRange
        }
        
        try fileHandle.seek(toOffset: fileOffset)
        guard let data = try? fileHandle.read(upToCount: range.count) else {
            throw StoreError.dataNotAvailable
        }
        
        return data
    }
    
}
