import AppKit
import Crypto
import Preferences
import Store

class ApplicationController: NSObject {
    
    let applicationWindowController = ApplicationWindowController(preferencesManager: .shared, biometricKeychain: .shared)
    var vault: Vault<SecureDataCryptor>?
    
    @objc func showPreferences() {
        applicationWindowController.showPreferences()
    }
    
    @objc func lock() {
        applicationWindowController.lock()
    }
    
    @objc func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        switch item.action {
        case #selector(lock):
            return applicationWindowController.isLockable
        case #selector(showPreferences):
            return applicationWindowController.canShowPreferences
        default:
            return true
        }
    }
    
}

extension ApplicationController: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        applicationWindowController.load()
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        BiometricKeychain.shared.invalidateAvailability()
    }
    
}
