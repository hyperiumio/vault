import Combine
import Foundation
import SwiftUI

class FileModel: ObservableObject, Identifiable {
    
    @Published var fileName = ""
    
    @Published var fileState: FileState {
        didSet {
            setupStateTransitions()
        }
    }
    
    var dataEntryCompleted: Bool {
        switch fileState {
        case .loaded:
            return true
        case .empty, .copying, .available, .loading:
            return false
        }
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
                .result()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
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
                .result()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
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

extension FileModel {
 
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
