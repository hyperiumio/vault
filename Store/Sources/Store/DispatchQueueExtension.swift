import Combine
import Foundation

extension DispatchQueue {
    
    func future<Success, Failure>(execute work: @escaping () -> Result<Success, Failure>) -> Future<Success, Failure> {
        return Future { promise in
            self.async {
                let result = work()
                promise(result)
            }
        }
    }
    
}
