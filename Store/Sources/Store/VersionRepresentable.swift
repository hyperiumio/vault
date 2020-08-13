import Foundation

let VersionRepresentableEncodingSize = 1

protocol VersionRepresentable: RawRepresentable {
    
    var encoded: Data { get }
    
    init(_ data: Data) throws
    
}

extension VersionRepresentable where RawValue == UInt8 {
    
    init(_ data: Data) throws {
        guard data.count == 1 else {
            throw VersionRepresentableError.invalidData
        }
        
        let versionValue = data[data.startIndex]
        guard let version = Self(rawValue: versionValue) else {
            throw VersionRepresentableError.unsupportedVersion
        }
        
        self = version
    }
    
    var encoded: Data {
        let bytes = [rawValue]
        return Data(bytes)
    }
    
}

enum VersionRepresentableError: Error {
    
    case invalidData
    case unsupportedVersion
    
}
