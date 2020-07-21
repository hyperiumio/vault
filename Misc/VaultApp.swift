import Localization
import SwiftUI

#if os(macOS)
@main
struct VaultApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            AppView(model: appDelegate.appModel)
        }
        .windowStyle(windowStyle)
        .commands {
            CommandGroup(before: .appTermination) {
                Button(LocalizedString.lockVault) {
                    
                }
            }
        }
        
        Settings {
            SettingsView(model: appDelegate.preferencesModel)
        }
    }
    
    var windowStyle: some WindowStyle { HiddenTitleBarWindowStyle() }
    
}
#endif

#if os(iOS)
@main
struct VaultApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppView(model: appDelegate.appModel)
        }
    }
    
}
#endif
