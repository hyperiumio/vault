import Foundation

func LoginEncode(_ login: Login) throws -> Data {
    do {
        return try JSONEncoder().encode(login)
    } catch {
        throw CodingError.encodingFailed
    }
}

func LoginDecode(data: Data) throws -> Login {
    do {
        return try JSONDecoder().decode(Login.self, from: data)
    } catch {
        throw CodingError.decodingFailed
    }
}
