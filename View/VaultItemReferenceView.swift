import SwiftUI

struct VaultItemReferenceView<Model>: View where Model: VaultItemReferenceModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
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
                VaultItemDisplayView(model)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            model.load()
        }
    }
    
}
