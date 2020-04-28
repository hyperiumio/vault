import Foundation

func NoteEncode(_ note: Note) throws -> Data {
    do {
        return try JSONEncoder().encode(note)
    } catch {
        throw CodingError.encodingFailed
    }
}

func NoteDecode(data: Data) throws -> Note {
    do {
        return try JSONDecoder().decode(Note.self, from: data)
    } catch {
        throw CodingError.decodingFailed
    }
}
