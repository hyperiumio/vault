import Foundation

protocol FileHandleRepresentable {
    
    func seek(toOffset offset: UInt64) throws
    func read(upToCount count: Int) throws -> Data?
    
}

class FileReader {
    
    private let fileHandle: FileHandleRepresentable
    private var isValid = true
    
    private init(fileHandle: FileHandleRepresentable) {
        self.fileHandle = fileHandle
    }
    
    func bytes(in range: Range<Int>) throws -> Data {
        guard isValid else {
            throw StorageError.invalidFileReader
        }
        
        guard let fileOffset = UInt64(exactly: range.startIndex) else {
            throw StorageError.invalidByteRange
        }
        
        try fileHandle.seek(toOffset: fileOffset)
        guard let data = try? fileHandle.read(upToCount: range.count) else {
            throw StorageError.dataNotAvailable
        }
        
        return data
    }
    
}

extension FileReader {
    
    static func read<T>(from fileHandle: FileHandleRepresentable, body: (FileReader) throws -> T) throws -> T {
        let fileReader = FileReader(fileHandle: fileHandle)
        defer {
            fileReader.isValid = false
        }
        
        return try body(fileReader)
    }
    
}
