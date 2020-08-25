import Crypto
import Preferences
import Sync

#if os(macOS)
import AppKit

class AppDelegate: NSObject {
    
    typealias VaultItemCreationModel = Vault.VaultItemCreationModel<VaultItemModel>
    typealias VaultItemReferenceModel = Vault.VaultItemReferenceModel<VaultItemModel>
    typealias SettingsModel = Vault.SettingsModel<ChangeMasterPasswordModel, BiometricUnlockPreferencesModel>
    typealias UnlockedModel = Vault.UnlockedModel<SettingsModel, VaultItemCreationModel, VaultItemReferenceModel>
    typealias AppModel = Vault.AppModel<BootstrapModel, SetupModel, LockedModel, UnlockedModel>
    
    let appModel: AppModel
    let syncCoordinator = SyncCoordinator()
    
    override init() {
        self.appModel = AppModel(preferencesManager: .shared, biometricKeychain: .shared)
        
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
    
    typealias VaultItemCreationModel = Vault.VaultItemCreationModel<VaultItemModel>
    typealias VaultItemReferenceModel = Vault.VaultItemReferenceModel<VaultItemModel>
    typealias SettingsModel = Vault.SettingsModel<ChangeMasterPasswordModel, BiometricUnlockPreferencesModel>
    typealias UnlockedModel = Vault.UnlockedModel<SettingsModel, VaultItemCreationModel, VaultItemReferenceModel>
    typealias AppModel = Vault.AppModel<BootstrapModel, SetupModel, LockedModel, UnlockedModel>
    
    let appModel: AppModel
    let syncCoordinator = SyncCoordinator()
    
    override init() {
        self.appModel = AppModel(preferencesManager: .shared, biometricKeychain: .shared)
        
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
