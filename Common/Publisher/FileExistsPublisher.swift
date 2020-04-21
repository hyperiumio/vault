import Combine
import Foundation

func FileExistsPublisher(url: URL) -> AnyPublisher<Bool, Never> {
    return Future { promise in
        DispatchQueue.global().async {
            let fileExists = FileManager.default.fileExists(atPath: url.path)
            let result = Result<Bool, Never>.success(fileExists)
            promise(result)
        }
    }.eraseToAnyPublisher()
}
