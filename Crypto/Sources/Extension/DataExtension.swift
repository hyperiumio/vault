import Foundation

extension Data {
    
    static let empty = Self()
    
    func map<T>(_ transform: (Self) throws -> T) rethrows -> T {
        return try transform(self)
    }
    
    var bytes: [UInt8] {
        return [UInt8](self)
    }
    
}
