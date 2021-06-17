import Model
import SwiftUI


struct VaultItemReferenceView<S>: View where S: VaultItemReferenceStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        Text("foo")
        /*
        Group {
            switch state.state {
            case .initialized:
                EmptyView()
            case .loading:
                ProgressView()
            case .loadingFailed:
                VStack {
                    Text(.loadingVaultItemFailed)
                        .font(.title3)
                    
                    
                    Button(.retry, role: nil) {
                        await state.load()
                    }
                    .padding()
                }
            case .loaded(let state):
                VaultItemView(state)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
             //   SecureItemTypeView(state.info.primaryType)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            async {
                await state.load()
            }
        }
         */
    }
    
}

#if DEBUG
struct VaultItemReferenceViewPreview: PreviewProvider {
    
    static let state: VaultItemReferenceStateStub = {
        fatalError()
    }()
    
    static var previews: some View {
        NavigationView {
            VaultItemReferenceView(state)
                .preferredColorScheme(.light)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
