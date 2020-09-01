import SwiftUI

struct VaultItemReferenceView<Model>: View where Model: VaultItemReferenceModelRepresentable {
    
    @ObservedObject var model: Model
    
    
    var body: some View {
        print(model.state)
        return Group {
            switch model.state {
            case .none:
                EmptyView()
            case .loading:
                EmptyView()
            case .loadingError:
                EmptyView()
            case .loaded(let model):
                VaultItemView(model, mode: .display)
            }
        }
        .onAppear(perform: model.load)
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}
