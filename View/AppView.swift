import Resource
import SwiftUI

struct AppView: View {
    
    @ObservedObject private var state: AppState

    init(_ state: AppState) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        Group {
            switch state.status {
            case .launching:
                Color.background
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
    #endif
    
    #if os(macOS)
    var body: some View {
        Group {
            switch state.status {
            case .launching:
                Color.background
                    .ignoresSafeArea()
                    .toolbar {
                        Spacer()
                    }
            case .launchingFailed:
                FailureView(Localized.appLaunchFailure) {
                    await state.bootstrap()
                }
                .toolbar {
                    Spacer()
                }
            case .setup(let setupState):
                SetupView(setupState)
                    .toolbar {
                        Spacer()
                    }
            case .locked(let lockedState):
                LockedView(lockedState)
                    .toolbar {
                        Spacer()
                    }
            case .unlocked(let unlockedState):
                UnlockedView(unlockedState)
            }
        }
        .frame(minWidth: 600, minHeight: 600)
        .task {
            await state.bootstrap()
        }
    }
    #endif
    
}

#if DEBUG
struct AppViewPreview: PreviewProvider {
    
    static let state = AppState(service: .stub)
    
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
