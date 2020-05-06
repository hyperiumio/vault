import Foundation

func WifiEncode(_ wifi: Wifi) throws -> Data {
    do {
        return try JSONEncoder().encode(wifi)
    } catch {
        throw CodingError.encodingFailed
    }
}

func WifiDecode(data: Data) throws -> Wifi {
    do {
        return try JSONDecoder().decode(Wifi.self, from: data)
    } catch {
        throw CodingError.decodingFailed
    }
}
