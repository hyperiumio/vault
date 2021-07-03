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
                Background()
            case .loading:
                ProgressView()
            case .display:
                Text("foo")
            case .edit(let editState):
                StoreItemEditView(editState) {
                    state.cancelEdit()
                }
            case .loadingFailed:
                FailureView(.loadingVaultFailed) {
                    await state.load()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await state.load()
        }
    }
    
}
