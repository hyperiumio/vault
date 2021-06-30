import Preferences
import SwiftUI

let service = try! Service()

@main
struct App: SwiftUI.App {
    
    @StateObject private var appState = AppState(service: service)
    
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
