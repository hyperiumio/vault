import Shim
import SwiftUI

struct StoreItemDetailView: View {
    
    @ObservedObject private var state: StoreItemDetailState
    
    init(_ state: StoreItemDetailState) {
        self.state = state
    }
    
    var body: some View {
        Group {
            switch state.status {
            case .initialized:
                Color.background
                    .ignoresSafeArea()
            case .loading:
                ProgressView()
            case let .display(storeItem):
                StoreItemDisplayView(storeItem.name, primaryItem: storeItem.primaryItem, secondaryItems: storeItem.secondaryItems, created: storeItem.created, modified: storeItem.modified) {
                    state.edit()
                }
            case let .edit(editState):
                StoreItemEditView(editState) {
                    state.cancelEdit()
                }
            case .loadingFailed:
                FailureView(.loadingVaultFailed) {
                    state.load()
                }
            }
        }
        .task {
            state.load()
        }
    }
    
}

#if DEBUG
struct StoreItemDetailViewPreview: PreviewProvider {
    
    static let state = StoreItemDetailState(storeItemInfo: AppServiceStub.storeItem.info, service: .stub)
    
    static var previews: some View {
        NavigationView {
            StoreItemDetailView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            StoreItemDetailView(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
