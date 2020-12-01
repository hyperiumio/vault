import Crypto
import Identifier
import Preferences
import Sync

class AppDelegate: NSObject {
    
    let appModel: AppModel<AppLockedDependency>
    let keychain: Keychain
    let syncCoordinator = SyncCoordinator()
    
    override init() {
        guard let appContainerDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Identifier.appGroup) else {
            fatalError()
        }
        guard let preferences = Preferences(appGroup: Identifier.appGroup) else {
            fatalError()
        }
        
        let vaultContainerDirectory = appContainerDirectory.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Application Support", isDirectory: true).appendingPathComponent("Vaults", isDirectory: true)
        let keychain = Keychain(accessGroup: Identifier.appGroup, identifier: Identifier.appBundleID)
        let appModelDependency = AppLockedDependency(vaultContainerDirectory: vaultContainerDirectory, preferences: preferences, keychain: keychain)
        
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
        syncCoordinator.startSync()
        completionHandler(.newData)
    }
    
}
#endif

#if os(macOS)
import AppKit

extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.registerForRemoteNotifications()
        syncCoordinator.initialize()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        keychain.invalidateAvailability()
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        syncCoordinator.startSync()
    }
    
}
#endif
