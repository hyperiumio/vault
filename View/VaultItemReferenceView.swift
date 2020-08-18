import SwiftUI

struct VaultItemReferenceView: View {
    
    @ObservedObject var model: VaultItemReferenceModel
    
    var body: some View {
        switch model.state {
        case .loading(let model):
            VaultItemLoadingView(model: model)
        case .loaded(let model):
            VaultItemView(model: model)
        }
    }
    
}
