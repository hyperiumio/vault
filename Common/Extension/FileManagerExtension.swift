import Combine
import Foundation

extension FileManager {
    
    func fileExistsPublisher(url: URL) -> Future<Bool, Never> {
        return Future { promise in
            DispatchQueue.global().async {
                let fileExists = self.fileExists(atPath: url.path)
                let result = Result<Bool, Never>.success(fileExists)
                promise(result)
            }
        }
    }
    
}
