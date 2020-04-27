import SwiftUI

struct VaultItemView: View {
    
    @ObservedObject var model: VaultItemModel
    
    var body: some View {
        switch model.state {
        case .loading(let model):
            return VaultItemLoadingView(model: model).eraseToAnyView()
        case .loaded(let model):
            return VaultItemLoadedView(model: model).eraseToAnyView()
        }
    }
    
}
