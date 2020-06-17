import Combine
import Foundation
import Store

class FileEditModel: ObservableObject, Identifiable {
    
    @Published var state: State {
        didSet {
            setupStateTransitions()
        }
    }
    
    var isComplete: Bool {
        guard case .loaded = state else {
            return false
        }
        
        return true
    }
    
    var secureItem: SecureItem? {
        guard case .loaded(let model) = state else {
            return nil
        }
        guard let file = model.fileItem else {
            return nil
        }
        
        return SecureItem.file(file)
    }
    
    private var stateTransitionSubscription: AnyCancellable?
    
    init(_ fileItem: FileItem? = nil) {
        if let fileItem = fileItem {
            let model = FileLoadedModel(fileItem)
            self.state = .loaded(model)
        } else {
            let model = FileEmptyModel()
            self.state = .empty(model)
        }
        
        setupStateTransitions()
    }
    
    private func setupStateTransitions() {
        switch state {
        case .empty(let model):
            stateTransitionSubscription = model.didReceiveUrl
                .receive(on: DispatchQueue.main)
                .result { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    
                    switch result {
                    case .success(let url):
                        let model = FileCopyingModel(fileUrl: url)
                        self.state = .copying(model)
                    case .failure:
                        break
                    }
                }
        case .copying(let model):
            stateTransitionSubscription = model.didReceiveData
                .receive(on: DispatchQueue.main)
                .result { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    
                    switch result {
                    case .success(let file):
                        let model = FileLoadedModel(file)
                        self.state = .loaded(model)
                    case .failure:
                        break
                    }
                }
            return
        case .loaded:
            return
        }
    }
    
}

extension FileEditModel {
    
    enum State {
        
        case empty(FileEmptyModel)
        case copying(FileCopyingModel)
        case loaded(FileLoadedModel)
        
    }
    
}
