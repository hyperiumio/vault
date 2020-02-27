import Foundation

func PasswordEncode(_ password: Password) throws -> Data {
    do {
        return try JSONEncoder().encode(password)
    } catch {
        throw CodingError.encodingFailed
    }
}

func PasswordDecode(data: Data) throws -> Password {
    do {
        return try JSONDecoder().decode(Password.self, from: data)
    } catch {
        throw CodingError.decodingFailed
    }
}
