import Combine
import Foundation

class FileEditModel: ObservableObject, Identifiable {
    
    @Published var fileName = ""
    
    @Published var fileState: FileState {
        didSet {
            setupStateTransitions()
        }
    }
    
    var isComplete: Bool {
        guard !fileName.isEmpty, case .loaded = fileState else {
            return false
        }
        
        return true
    }
    
    var secureItem: SecureItem? {
        guard !fileName.isEmpty, case .loaded(let model) = fileState else {
            return nil
        }
        
        let attributes = File.Attributes(filename: fileName, fileExtension: "")
        let file = File(attributes: attributes, fileData: model.data)
        return SecureItem.file(file)
    }
    
    private var stateTransitionSubscription: AnyCancellable?
    
    init(initialState: InitialState) {
        switch initialState {
        case .empty:
            let model = FileStateEmptyModel()
            self.fileState = .empty(model)
        }
        
        setupStateTransitions()
    }
    
    private func setupStateTransitions() {
        switch fileState {
        case .empty(let model):
            stateTransitionSubscription = model.didReceiveUrl
                .receive(on: DispatchQueue.main)
                .result { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    
                    switch result {
                    case .success(let url):
                        let model = FileStateCopyingModel(fileUrl: url)
                        self.fileState = .copying(model)
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
                    case .success(let data):
                        let model = FileStateLoadedModel(data: data)
                        self.fileState = .loaded(model)
                    case .failure:
                        break
                    }
                }
            return
        case .available:
            return
        case .loading:
            return
        case .loaded:
            return
        }
    }
    
}

extension FileEditModel {
 
    enum InitialState {
        
        case empty
        
    }
    
    enum FileState {
        
        case empty(FileStateEmptyModel)
        case copying(FileStateCopyingModel)
        case available
        case loading
        case loaded(FileStateLoadedModel)
        
    }
    
}
