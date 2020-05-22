import Crypto
import Foundation

class FileReader: DataContext {
    
    private let fileHandle: FileHandle
    private let offset: Int
    private var isValid = true
    
    private init(fileHandle: FileHandle, offset: Int = 0) {
        self.fileHandle = fileHandle
        self.offset = offset
    }
    
    func bytes(in range: Range<Int>) throws -> Data {
        guard isValid else {
            throw DataContextError.invalidContext
        }
        
        let startIndex = range.startIndex + offset
        guard let fileOffset = UInt64(exactly: startIndex) else {
            throw DataContextError.invalidByteRange
        }
        do {
            try fileHandle.seek(toOffset: fileOffset)
        } catch {
            throw DataContextError.invalidByteRange
        }
        
        guard let data = try? fileHandle.read(upToCount: range.count) else {
            throw DataContextError.dataNotAvailable
        }
        
        return data
    }
    
    func byte(at index: Int) throws -> Data {
        guard isValid else {
            throw DataContextError.invalidContext
        }
        
        let index = index + offset
        guard let fileOffset = UInt64(exactly: index) else {
            throw DataContextError.invalidIndex
        }
        do {
            try fileHandle.seek(toOffset: fileOffset)
        } catch {
            throw DataContextError.invalidIndex
        }
        
        guard let data = try? fileHandle.read(upToCount: 1) else {
            throw DataContextError.dataNotAvailable
        }
        
        return data
    }
    
    func offset(by delta: Int) -> DataContext {
        let offset = self.offset + delta
        return FileReader(fileHandle: fileHandle, offset: offset)
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
