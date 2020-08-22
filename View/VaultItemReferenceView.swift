import SwiftUI

struct VaultItemReferenceView<Model>: View where Model: VaultItemReferenceModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        switch model.state {
        case .none:
            EmptyView()
        case .loading:
            EmptyView()
        case .loadingError:
            EmptyView()
        case .loaded(let model):
            VaultItemView(model: model)
        }
    }
    
}
