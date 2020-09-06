import SwiftUI

struct VaultItemReferenceView<Model>: View where Model: VaultItemReferenceModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Group {
            switch model.state {
            case .none:
                EmptyView()
            case .loading:
                EmptyView()
            case .loadingError:
                EmptyView()
            case .loaded(let model):
                ScrollView {
                    VaultItemView(model, mode: .display)
                }
            }
        }
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}
