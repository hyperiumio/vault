import Combine
import Crypto
import Identifier
import Preferences
import Storage

class AppDelegate: NSObject {
    
    let appModel: AppModel<AppLockedDependency>
    let keychain: Keychain
    
    private var serverInitialized: AnyCancellable?
    
    override init() {
        guard let containerDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Identifier.appGroup)?.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Application Support", isDirectory: true).appendingPathComponent("Vaults", isDirectory: true) else {
            fatalError()
        }
        
        
        guard let userDefaults = UserDefaults(suiteName: Identifier.appGroup) else {
            fatalError()
        }
        
        let preferences = Preferences(using: userDefaults)
        let keychain = Keychain(accessGroup: Identifier.appGroup)
        let appModelDependency = AppLockedDependency(containerDirectory: containerDirectory, preferences: preferences, keychain: keychain)
        
        self.appModel = AppModel(appModelDependency)
        self.keychain = keychain
        
        super.init()
    }
    
}

#if os(iOS)
import UIKit

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.ignoreSnapshotOnNextApplicationLaunch()
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        keychain.invalidateAvailability()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
}
#endif

#if os(macOS)
import AppKit

extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.registerForRemoteNotifications()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        keychain.invalidateAvailability()
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        
    }
    
}
#endif
