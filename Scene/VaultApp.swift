import SwiftUI

@main
struct VaultApp: App {
    
    @StateObject var state: AppState<AppLockedDependency> = {
        let dependency = AppLockedDependency()
        return AppState(dependency)
    }()
    
    #if os(iOS)
    var body: some Scene {
        WindowGroup {
            AppView(state)
        }
    }
    #endif
    
    #if os(macOS)
    var body: some Scene {
        WindowGroup {
            AppView(state)
                .frame(width: 600, height: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            AppCommands(state)
        }
    }
    #endif
    
}
