import Combine
import Foundation
import Store

class FileCopyingModel: ObservableObject {
    
    @Published var progress: Double = 0
    
    let didReceiveData = PassthroughSubject<FileItem, Never>()
    
    init(fileUrl: URL) {
        let task = URLSession.shared.dataTask(with: fileUrl) { [didReceiveData] data, response, error in
            if let _ = error {
                assertionFailure()
            }
            guard let data = data else { return }
            
            let fileItem = FileItem(name: fileUrl.lastPathComponent, data: data)
            didReceiveData.send(fileItem)
        }

        task.progress.publisher(for: \.fractionCompleted)
            .receive(on: DispatchQueue.main)
            .assign(to: $progress)
        
        task.resume()
    }
    
}
