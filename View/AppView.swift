import Resource
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
                Color.background
                    .ignoresSafeArea()
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

#if DEBUG
struct AppViewPreview: PreviewProvider {
    
    static let service = BootstrapServiceStub()
    static let state = AppState(dependency: service)
    
    static var previews: some View {
        AppView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        AppView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
