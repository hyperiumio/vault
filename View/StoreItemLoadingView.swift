import SwiftUI

struct StoreItemLoadingView: View {
    
    @ObservedObject private var state: StoreItemLoadingState
    
    init(_ state: StoreItemLoadingState) {
        self.state = state
    }
    
    var body: some View {
        Group {
            switch state.status {
            case .initialized:
                Background()
            case .loading:
                ProgressView()
            case .loadingFailed:
                FailureView(.loadingVaultFailed) {
                    await state.load()
                }
            case .loaded(let state):
                StoreItemDetailView(state)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await state.load()
        }
    }
    
}
