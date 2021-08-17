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
                FailureView(.appLaunchFailure, reload: state.bootstrap)
            case let .setup(setupState):
                SetupView(setupState)
            case let .locked(lockedState):
                LockedView(lockedState)
            case let .unlocked(unlockedState):
                UnlockedView(unlockedState)
            }
        }
        .onAppear {
            state.bootstrap()
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
                FailureView(.appLaunchFailure) {
                    await state.bootstrap()
                }
                .toolbar {
                    Spacer()
                }
            case let .setup(setupState):
                SetupView(setupState)
                    .toolbar {
                        Spacer()
                    }
            case let .locked(lockedState):
                LockedView(lockedState)
                    .toolbar {
                        Spacer()
                    }
            case let .unlocked(unlockedState):
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
