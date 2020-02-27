import Foundation

class FileReader: ByteBufferContext {
    
    private let fileHandle: FileHandle
    private var isValid = true
    
    private init(fileHandle: FileHandle) {
        self.fileHandle = fileHandle
    }
    
    func bytes(in range: Range<Int>) throws -> Data {
        guard isValid else {
            throw ByteBufferContextError.invalidContext
        }
        
        guard let offset = UInt64(exactly: range.startIndex) else {
            throw ByteBufferContextError.invalidByteRange
        }
        do {
            try fileHandle.seek(toOffset: offset)
        } catch {
            throw ByteBufferContextError.invalidByteRange
        }
        
        guard let data = try? fileHandle.read(upToCount: range.count) else {
            throw ByteBufferContextError.dataNotAvailable
        }
        
        return data
    }
    
    func bytes() throws -> Data {
        guard isValid else {
            throw ByteBufferContextError.invalidContext
        }
        
        do {
            try fileHandle.seek(toOffset: 0)
        } catch {
            throw ByteBufferContextError.invalidByteRange
        }
        
        guard let data = try? fileHandle.readToEnd() else {
            throw ByteBufferContextError.dataNotAvailable
        }
        
        return data
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
