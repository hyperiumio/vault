import SwiftUI

struct FileEditView: View {
    
    @ObservedObject var model: FileEditModel
    
    var body: some View {
        switch model.state {
        case .empty(let model):
            FileStateEmptyView(model: model)
        case .copying(let model):
            FileStateCopyingView(model: model)
        case .loaded(let model):
            FileStateLoadedView(model: model)
        }
    }
    
}
