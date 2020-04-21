import Foundation

func VaultItemInfoEncode(_ info: VaultItem.Info) throws -> Data {
    do {
        return try JSONEncoder().encode(info)
    } catch {
        throw CodingError.encodingFailed
    }
}

func VaultItemInfoDecode(data: Data) throws -> VaultItem.Info {
    do {
        return try JSONDecoder().decode(VaultItem.Info.self, from: data)
    } catch {
        throw CodingError.decodingFailed
    }
}
