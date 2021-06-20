import SwiftUI

@main
struct VaultApp: App {
    
    @StateObject var state: AppState<AppLockedDependency> = {
        let dependency = AppLockedDependency()
        return AppState(dependency)
    }()
    
    var body: some Scene {
        WindowGroup {
            AppView(state)
                #if os(macOS)
                .frame(width: 600, height: 600)
                #endif
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            AppCommands(state)
        }
        #endif
    }
    
}
