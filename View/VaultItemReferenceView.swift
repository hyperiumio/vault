import SwiftUI

struct VaultItemReferenceView<Model>: View where Model: VaultItemReferenceModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            switch model.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .loadingFailure:
                Text("Loading did fail")
            case .loaded(let model):
                VaultItemView(model)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                SecureItemTypeView(model.info.primaryType)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            model.load()
        }
    }
    
}
