import Crypto
import Preferences
import Sync

#if os(macOS)
import AppKit

class AppDelegate: NSObject {
    
    let appModel: AppModel
    let preferencesModel: LockedSettingsModel
    let syncCoordinator = SyncCoordinator()
    
    override init() {
        let appModelContext = AppModelContext(preferencesManager: .shared, biometricKeychain: .shared)
        let preferencesModelContext = PreferencesModelContext(preferencesManager: .shared, biometricKeychain: .shared)
        
        self.appModel = AppModel(context: appModelContext)
        self.preferencesModel = LockedSettingsModel(context: preferencesModelContext)
        
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
    
    let appModel: AppModel
    let syncCoordinator = SyncCoordinator()
    
    override init() {
        let appModelContext = AppModelContext(preferencesManager: .shared, biometricKeychain: .shared)
        
        self.appModel = AppModel(context: appModelContext)
        
        super.init()
    }
    
}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
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
