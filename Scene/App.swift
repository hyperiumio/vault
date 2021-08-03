import SwiftUI
import Resource

@main
struct App: SwiftUI.App {
    
    @StateObject private var appState = AppState(service: .production)
    
    #if os(iOS)
    var body: some Scene {
        WindowGroup {
            AppView(appState)
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
                Button(Localized.lockVault) {
                    Task {
                        await AppService.production.lock()
                    }
                }
            }
        }
    }
    #endif
    
}
