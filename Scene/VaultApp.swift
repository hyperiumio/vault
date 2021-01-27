import Combine
import SwiftUI

#if os(macOS)
@main
struct VaultApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var settingsModel: SettingsModel<AppUnlockedDependency>?
    
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
            Group {
                if let settingsModel = settingsModel {
                    SettingsView(settingsModel)
                } else {
                    Text("Locked")
                        .padding()
                }
            }
            .frame(width: 600)
            .onReceive(settingsModelPublisher) { settingsModel in
                self.settingsModel = settingsModel
            }
        }
    }
    
    var settingsModelPublisher: AnyPublisher<SettingsModel<AppUnlockedDependency>?, Never> {
        appDelegate.appModel.$state
            .flatMap { state -> AnyPublisher<SettingsModel<AppUnlockedDependency>?, Never> in
                guard case .main(let model) = state else {
                    return Just(nil).eraseToAnyPublisher()
                }
                
                return model.$state
                    .map { state in
                        guard case .unlocked(let model, _) = state else {
                            return nil
                        }
                        
                        return model.settingsModel
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
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
