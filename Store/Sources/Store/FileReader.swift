import Foundation

// TODO: remove shim after setting deployment target to 10.16
extension FileHandle {
    
    func read(upToCount count: Int) throws -> Data? {
        return readData(ofLength: count)
    }
    
}

public final class FileReader {
    
    private let fileHandle: FileHandle
    private let offset: Int
    private var isValid = true
    
    private init(fileHandle: FileHandle, offset: Int = 0) {
        self.fileHandle = fileHandle
        self.offset = offset
    }
    
    public func bytes(in range: Range<Int>) throws -> Data {
        guard isValid else {
            throw NSError()
        }
        
        let startIndex = range.startIndex + offset
        guard let fileOffset = UInt64(exactly: startIndex) else {
            throw NSError()
        }
        do {
            try fileHandle.seek(toOffset: fileOffset)
        } catch {
            throw NSError()
        }
        
        guard let data = try? fileHandle.read(upToCount: range.count) else {
            throw NSError()
        }
        
        return data
    }
    
    public func byte(at index: Int) throws -> Data {
        guard isValid else {
            throw NSError()
        }
        
        let index = index + offset
        guard let fileOffset = UInt64(exactly: index) else {
            throw NSError()
        }
        do {
            try fileHandle.seek(toOffset: fileOffset)
        } catch {
            throw NSError()
        }
        
        guard let data = try? fileHandle.read(upToCount: 1) else {
            throw NSError()
        }
        
        return data
    }
    
    public func offset(by delta: Int) -> FileReader {
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
