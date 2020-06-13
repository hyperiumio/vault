import Foundation

extension Data {
    
    func map<T>(_ transform: (Self) throws -> T) rethrows -> T {
        return try transform(self)
    }
    
}


