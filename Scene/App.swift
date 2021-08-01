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
                .frame(width: 400, height: 400)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            AppCommands()
        }
    }
    #endif
    
}
