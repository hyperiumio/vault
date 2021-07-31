import SwiftUI

@main
struct App: SwiftUI.App {
    
    @StateObject private var appState = AppState(dependency: .production)
    
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
                .frame(width: 600, height: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            AppCommands()
        }
    }
    #endif
    
}
