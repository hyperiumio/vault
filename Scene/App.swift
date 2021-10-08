import SwiftUI

@main
struct Apps: App {
    
    static let service = AppService()
    
    @StateObject private var asyncAppState = AsyncState {
        try await AppState(service: service)
    }
    
    #if os(iOS)
    var body: some Scene {
        WindowGroup {
            AsyncView(asyncAppState) { state in
                AppView(state)
            } failure: {
                FailureView(.appLaunchFailure) {
                    asyncAppState.reload()
                }
            }
        }
    }
    #endif
    
    #if os(macOS)
    var body: some Scene {
        WindowGroup {
            AppView(appState)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            SidebarCommands()
            
            CommandGroup(before: .appTermination) {
                Button(.lockVault) {
                    Task {
                        await AppService.production.lock()
                    }
                }
            }
        }
    }
    #endif
    
}
