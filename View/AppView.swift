import Asset
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
                FailureView(Localized.appLaunchFailure) {
                    await state.bootstrap()
                }
            case .setup(let setupState):
                SetupView(setupState)
            case .locked(let lockedState):
                LockedView(lockedState)
            case .unlocked(let unlockedState):
                UnlockedView(unlockedState)
            }
        }
        .task {
            await state.bootstrap()
        }
    }
    
}
