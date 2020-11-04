import Localization
import SwiftUI

#if os(iOS)
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
                    Text(LocalizedString.loadingVaultItemFailed)
                        .font(.title3)
                    
                    Button(LocalizedString.retry, action: model.load)
                        .padding()
                }
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
#endif

#if os(iOS) && DEBUG
struct VaultItemReferenceViewPreview: PreviewProvider {
    
    static let model: VaultItemReferenceModelStub = {
        let info = VaultItemInfo(id: UUID(), name: "foo", description: "bar", primaryType: .login, secondaryTypes: [], created: .distantPast, modified: .distantFuture)
        return VaultItemReferenceModelStub(state: .loadingFailed, info: info)
    }()
    
    static var previews: some View {
        Group {
            NavigationView {
                VaultItemReferenceView(model)
                    .preferredColorScheme(.light)
            }
            
            NavigationView {
                VaultItemReferenceView(model)
                    .preferredColorScheme(.dark)
            }
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
