import SwiftUI

@main
struct VaultApp: App {
    
    @StateObject var model: AppModel<AppLockedDependency> = {
        let dependency = AppLockedDependency()
        return AppModel(dependency)
    }()
    
    #if os(iOS)
    var body: some Scene {
        WindowGroup {
            AppView(model)
        }
    }
    #endif
    
    #if os(macOS)
    var body: some Scene {
        WindowGroup {
            AppView(model)
                .frame(width: 600, height: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            AppCommands(model)
        }
    }
    #endif
    
}
