import SwiftUI

struct VaultItemDisplayView: View {
    
    @ObservedObject var model: VaultItemDisplayModel
    
    var body: some View {
        switch model.state {
        case .loading(let model):
            return VaultItemLoadingView(model: model).eraseToAnyView()
        case .loaded(let model):
            return VaultItemLoadedView(model: model).eraseToAnyView()
        }
    }
    
}
