import Foundation

let VersionRepresentableByteCount = 1

protocol VersionRepresentable: RawRepresentable {
    
    var encoded: Data { get }
    
    init(_ value: UInt8) throws
    
}

extension VersionRepresentable where RawValue == UInt8 {
    
    init(_ value: UInt8) throws {
        guard let version = Self(rawValue: value) else {
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
    
    case unsupportedVersion
    
}
