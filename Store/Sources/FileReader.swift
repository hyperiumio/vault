import Foundation

public final class FileReader {
    
    private let fileHandle: FileHandle
    private var isValid = true
    
    private init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }
    
    public func bytes(in range: Range<Int>) throws -> Data {
        guard isValid else {
            throw FileReaderError.invalidFileReader
        }
        
        guard let fileOffset = UInt64(exactly: range.startIndex) else {
            throw FileReaderError.invalidByteRange
        }
        
        try fileHandle.seek(toOffset: fileOffset)
        guard let data = try? fileHandle.read(upToCount: range.count) else {
            throw FileReaderError.dataNotAvailable
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

enum FileReaderError: Error {
    
    case invalidFileReader
    case invalidByteRange
    case dataNotAvailable
    
}
