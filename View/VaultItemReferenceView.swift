import Storage
import SwiftUI

struct VaultItemReferenceView<Model>: View where Model: VaultItemReferenceModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
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
                    
                    Button(.retry, action: model.load)
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
    #endif
    
    #if os(macOS)
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
                    
                    Button(.retry, action: model.load)
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
        .onAppear {
            model.load()
        }
    }
    #endif
    
}

#if DEBUG
struct VaultItemReferenceViewPreview: PreviewProvider {
    
    static let model: VaultItemReferenceModelStub = {
        fatalError()
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
