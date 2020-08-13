import Foundation

protocol BinaryCodable: Codable, Equatable {
    
    init(binaryEncoded: Data) throws
    
    func binaryEncoded() throws -> Data
    
}

extension BinaryCodable {
    
    func binaryEncoded() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let encodedValue = try encoder.encode(self)
        return BinaryCodableVersion.version1.encoded + encodedValue
    }
    
    init(binaryEncoded data: Data) throws {
        let versionRange = Range(lowerBound: data.startIndex, count: VersionRepresentableEncodingSize)
        let versionData = data[versionRange]
        let version = try BinaryCodableVersion(versionData)
        let payload = data[versionRange.upperBound...]
        
        switch version  {
        case .version1:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            self = try decoder.decode(Self.self, from: payload)
        }
    }
    
}

private enum BinaryCodableVersion: UInt8, VersionRepresentable {
    
    case version1 = 1
    
}
