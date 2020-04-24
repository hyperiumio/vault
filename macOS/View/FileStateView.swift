import SwiftUI

struct FileStateView: View {
    
    let fileState: FileEditModel.FileState
    
    var body: some View {
        switch fileState {
        case .empty(let model):
            return FileStateEmptyView(model: model).eraseToAnyView()
        case .copying(let model):
            return FileStateCopyingView(model: model).eraseToAnyView()
        case .available:
            fatalError()
        case .loading:
            fatalError()
        case .loaded(let model):
            return FileStateLoadedView(model: model).eraseToAnyView()
        }
    }
    
}

