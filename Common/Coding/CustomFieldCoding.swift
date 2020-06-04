import Foundation

func CustomFieldEncode(_ customField: CustomField) throws -> Data {
    do {
        return try JSONEncoder().encode(customField)
    } catch {
        throw CodingError.encodingFailed
    }
}

func CustomFieldDecode(data: Data) throws -> CustomField {
    do {
        return try JSONDecoder().decode(CustomField.self, from: data)
    } catch {
        throw CodingError.decodingFailed
    }
}
