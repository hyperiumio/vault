import Foundation

public final class FileReader {
    
    private let fileHandle: FileHandle
    private var isValid = true
    
    private init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }
    
    public func bytes(in range: Range<Int>) throws -> Data {
        guard isValid else {
            throw StoreError.invalidFileReader
        }
        
        guard let fileOffset = UInt64(exactly: range.startIndex) else {
            throw StoreError.invalidByteRange
        }
        
        try fileHandle.seek(toOffset: fileOffset)
        guard let data = try? fileHandle.read(upToCount: range.count) else {
            throw StoreError.dataNotAvailable
        }
        
        return data
    }
    
    func invalidate() {
        isValid = false
    }
    
}

extension FileReader {
    
    public static func read<T>(url: URL, body: (FileReader) throws -> T) throws -> T {
        let fileHandle = try FileHandle(forReadingFrom: url)
        let fileReader = FileReader(fileHandle: fileHandle)
        defer {
            fileReader.invalidate()
        }
        
        return try body(fileReader)
    }
    
}
