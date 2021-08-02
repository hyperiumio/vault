import SwiftUI

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
                .frame(minWidth: 600, minHeight: 500)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            AppCommands()
        }
    }
    #endif
    
}
