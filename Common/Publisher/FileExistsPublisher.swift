import Combine
import Foundation

func FileExistsPublisher(url: URL) -> AnyPublisher<Bool, Never> {
    return Future { promise in
        DispatchQueue.global().async {
            let keyExists = FileManager.default.fileExists(atPath: url.path)
            let result = Result<Bool, Never>.success(keyExists)
            promise(result)
        }
    }.eraseToAnyPublisher()
}
