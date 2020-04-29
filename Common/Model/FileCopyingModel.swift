import Combine
import Foundation

class FileCopyingModel: ObservableObject {
    
    @Published var progress: Double = 0
    
    let didReceiveData = PassthroughSubject<File, Error>()
    
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
            
            let file = File(name: fileUrl.lastPathComponent, data: data)
            didReceiveData.send(file)
        }

        progressSubscription = task.progress.publisher(for: \.fractionCompleted)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.progress = value
            }
        
        task.resume()
    }
    
}
