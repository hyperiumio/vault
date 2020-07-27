import Combine
import Foundation
import Store

class FileEditModel: ObservableObject, Identifiable {
    
    @Published var state: State {
        didSet {
            switch state {
            case .empty(let model):
                model.didReceiveUrl
                    .map { url in
                        let model = FileCopyingModel(fileUrl: url)
                        return .copying(model)
                    }
                    .receive(on: DispatchQueue.main)
                    .assign(to: &$state)
            case .copying(let model):
                model.didReceiveData
                    .map { file in
                        let model = FileLoadedModel(file)
                        return .loaded(model)
                    }
                    .receive(on: DispatchQueue.main)
                    .assign(to: &$state)
                return
            case .loaded:
                return
            }
        }
    }
    
    var fileItem: FileItem {
        guard case .loaded(let model) = state else {
            return FileItem()
        }
        
        return model.fileItem
    }
    
    init(_ fileItem: FileItem) {
        let model = FileLoadedModel(fileItem)
        self.state = .loaded(model)
    }
    
    init() {
        let model = FileEmptyModel()
        self.state = .empty(model)
    }
    
}

extension FileEditModel {
    
    enum State {
        
        case empty(FileEmptyModel)
        case copying(FileCopyingModel)
        case loaded(FileLoadedModel)
        
    }
    
}
