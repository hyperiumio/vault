import SwiftUI

struct FileEditView: View {
    
    @ObservedObject var model: FileEditModel
    
    var body: some View {
        switch model.state {
        case .empty(let model):
            return FileStateEmptyView(model: model).eraseToAnyView()
        case .copying(let model):
            return FileStateCopyingView(model: model).eraseToAnyView()
        case .loaded(let model):
            return FileStateLoadedView(model: model).eraseToAnyView()
        }
    }
    
}
