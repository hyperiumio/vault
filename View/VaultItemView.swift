import SwiftUI

struct VaultItemView: View {
    
    @ObservedObject var model: VaultItemModel
    
    var body: some View {
        switch model.state {
        case .loading(let model):
            VaultItemLoadingView(model: model)
        case .loaded(let model):
            VaultItemLoadedView(model: model)
        }
    }
    
}
