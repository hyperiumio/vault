import Crypto
import Foundation

class FileReader: DataContext {
    
    private let fileHandle: FileHandle
    private var isValid = true
    
    private init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }
    
    func bytes(in range: Range<Int>) throws -> [UInt8] {
        guard isValid else {
            throw DataContextError.invalidContext
        }
        
        guard let offset = UInt64(exactly: range.startIndex) else {
            throw DataContextError.invalidByteRange
        }
        do {
            try fileHandle.seek(toOffset: offset)
        } catch {
            throw DataContextError.invalidByteRange
        }
        
        guard let bytes = try? fileHandle.read(upToCount: range.count)?.bytes else {
            throw DataContextError.dataNotAvailable
        }
        
        return bytes
    }
    
    func invalidate() {
        isValid = false
    }
    
}

extension FileReader {
    
    static func read<T>(url: URL, body: (FileReader) throws -> T) throws -> T {
        guard url.isFileURL else {
            throw FileReaderError.invalidUrl
        }
        guard let fileHandle = try? FileHandle(forReadingFrom: url) else {
            throw FileReaderError.fileOpenFailed
        }
        
        let fileReader = FileReader(fileHandle: fileHandle)
        defer {
            fileReader.invalidate()
        }
        
        return try body(fileReader)
    }
    
}

enum FileReaderError: Error {
    
    case invalidUrl
    case fileOpenFailed
    
}
