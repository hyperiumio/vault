import Resource
import SwiftUI

struct QuickAccessView: View {
    
    @ObservedObject private var state: QuickAccessState
    private let cancel: () -> Void
    
    init(_ state: QuickAccessState, cancel: @escaping () -> Void) {
        self.state = state
        self.cancel = cancel
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch state.status {
                case .initialized:
                    Background()
                case .loading:
                    ProgressView()
                case .loadingFailed:
                    FailureView(Localized.loadingVaultFailed) {
                        Task {
                            await state.load()
                        }
                    }
                case .locked(let state):
                    LockedView(state)
                case .unlocked(let state):
                    QuickAccessUnlockedView(state)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Localized.cancel) {
                        cancel()
                    }
                }
            }
            .task {
                await state.load()
            }
        }
    }
    
}
