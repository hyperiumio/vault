import Combine
import SwiftUI

#if os(macOS)
@main
struct VaultApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppView(appDelegate.appModel)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .commands {
            SidebarCommands()
            
            CommandGroup(before: .appTermination) {
                Button(.lockVault) {
                    guard case .main(let model) = appDelegate.appModel.state else { return }
                    
                    model.lock()
                }
                
            }
        }
        
        Settings {
            
        }
    }
    
}
#endif

#if os(iOS)
@main
struct VaultApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppView(appDelegate.appModel)
        }
    }
    
}
#endif
