import Foundation

func FileEncode(_ file: File) throws -> Data {
    do {
        let container = [
            try JSONEncoder().encode(file.attributes),
            file.fileData
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
        let attributes = try JSONDecoder().decode(File.Attributes.self, from: encodedAttributes)
        
        guard let fileData = container[.fileDataIndex] else {
            throw CodingError.decodingFailed
        }
        
        return File(attributes: attributes, fileData: fileData)
    } catch {
        throw CodingError.encodingFailed
    }
}

private extension Int {
    
    static let attributesIndex = 0
    static let fileDataIndex = 1
    
}
