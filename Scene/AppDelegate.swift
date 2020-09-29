import Crypto
import Preferences
import Sync

class AppDelegate: NSObject {
    
    let appModel: AppModel<AppLockedDependency>
    let keychain = Keychain(identifier: "io.hyperium.vault")
    let syncCoordinator = SyncCoordinator()
    
    override init() {
        let appModelDependency = AppLockedDependency(preferencesManager: .shared, keychain: keychain)
        self.appModel = AppModel(appModelDependency)
        
        super.init()
    }
    
}

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
