import Combine
import Foundation

extension Data {
    
    func map<T>(_ transform: (Self) throws -> T) rethrows -> T {
        return try transform(self)
    }
    
    static func provider(contentsOf url: URL) -> Future<Self, Error> {
        return Future { promise in
            DispatchQueue.global().async {
                let result = Result {
                    return try Data(contentsOf: url)
                }
                promise(result)
            }
        }
    }
    
}
