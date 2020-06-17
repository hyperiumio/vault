import Combine
import Foundation
import Store

class FileCopyingModel: ObservableObject {
    
    @Published var progress: Double = 0
    
    let didReceiveData = PassthroughSubject<FileItem, Error>()
    
    private var progressSubscription: AnyCancellable?
    
    init(fileUrl: URL) {
        let task = URLSession.shared.dataTask(with: fileUrl) { [didReceiveData] data, response, error in
            if let error = error {
                let completion = Subscribers.Completion.failure(error)
                didReceiveData.send(completion: completion)
                return
            }
            guard let data = data else {
                return
            }
            
            let fileItem = FileItem(name: fileUrl.lastPathComponent, data: data)
            didReceiveData.send(fileItem)
        }

        progressSubscription = task.progress.publisher(for: \.fractionCompleted)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.progress = value
            }
        
        task.resume()
    }
    
}
