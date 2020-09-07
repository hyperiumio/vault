import Crypto
import Preferences
import Sync

#if os(macOS)
import AppKit

class AppDelegate: NSObject {
    
    let appModel: AppModel<AppLockedDependency>
    let syncCoordinator = SyncCoordinator()
    
    override init() {
        let appModelDependency = AppLockedDependency(preferencesManager: .shared, biometricKeychain: .shared)
        self.appModel = AppModel(appModelDependency)
        
        super.init()
    }
    
}

extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.registerForRemoteNotifications()
        syncCoordinator.initialize()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        BiometricKeychain.shared.invalidateAvailability()
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        syncCoordinator.startSync()
    }
    
}
#endif

#if os(iOS)
import UIKit

class AppDelegate: NSObject {
    
    let appModel: AppModel<AppLockedDependency>
    let syncCoordinator = SyncCoordinator()
    
    override init() {
        
        let dependency = AppLockedDependency(preferencesManager: .shared, biometricKeychain: .shared)
        self.appModel = AppModel(dependency)
        
        super.init()
    }
    
}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.ignoreSnapshotOnNextApplicationLaunch()
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        BiometricKeychain.shared.invalidateAvailability()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        syncCoordinator.startSync()
        completionHandler(.newData)
    }
    
}
#endif
