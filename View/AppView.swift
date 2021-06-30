import SwiftUI

struct AppView: View {
    
    @ObservedObject private var state: AppState

    init(_ state: AppState) {
        self.state = state
    }
    
    var body: some View {
        Group {
            switch state.status {
            case .launching:
                Background()
            case .launchingFailed:
                FailureView(.appLaunchFailure) {
                    await state.bootstrap()
                }
            case .setup(let state):
                SetupView(state)
            case .locked(let state):
                LockedView(state)
            case .unlocked(let state):
                UnlockedView(state)
            }
        }
        .task {
            await state.bootstrap()
        }
    }
    
}
