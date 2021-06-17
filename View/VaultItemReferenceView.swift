import Persistence
import SwiftUI


struct VaultItemReferenceView<Model>: View where Model: VaultItemReferenceModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            switch model.state {
            case .initialized:
                EmptyView()
            case .loading:
                ProgressView()
            case .loadingFailed:
                VStack {
                    Text(.loadingVaultItemFailed)
                        .font(.title3)
                    
                    
                    Button(.retry, role: nil) {
                        await model.load()
                    }
                    .padding()
                }
            case .loaded(let model):
                VaultItemView(model)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
             //   SecureItemTypeView(model.info.primaryType)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            async {
                await model.load()
            }
        }
    }
    
}

#if DEBUG
struct VaultItemReferenceViewPreview: PreviewProvider {
    
    static let model: VaultItemReferenceModelStub = {
        fatalError()
    }()
    
    static var previews: some View {
        NavigationView {
            VaultItemReferenceView(model)
                .preferredColorScheme(.light)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
