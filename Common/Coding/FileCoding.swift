import Foundation

func FileEncode(_ file: File) throws -> Data {
    do {
        let container = [
            try JSONEncoder().encode(file.name),
            file.data
        ] as DataContainer
        return try container.encode()
    } catch {
        throw CodingError.encodingFailed
    }
}

func FileDecode(data: Data) throws -> File {
    do {
        let container = try DataContainer.decode(data: data)
        
        guard let encodedAttributes = container[.attributesIndex] else {
            throw CodingError.decodingFailed
        }
        guard let fileData = container[.fileDataIndex] else {
            throw CodingError.decodingFailed
        }
        
        let filename = try JSONDecoder().decode(String.self, from: encodedAttributes)
        
        return File(name: filename, data: fileData)
    } catch {
        throw CodingError.encodingFailed
    }
}

private extension Int {
    
    static let attributesIndex = 0
    static let fileDataIndex = 1
    
}
