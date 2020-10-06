import Combine
import Foundation

extension DispatchQueue {
    
    func future<Success>(catching body: @escaping () throws -> Success) -> Future<Success, Error> {
        Future { promise in
            self.async {
                let result = Result(catching: body)
                promise(result)
            }
        }
    }
    
}
