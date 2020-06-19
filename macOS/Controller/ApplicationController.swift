import AppKit
import Crypto
import Preferences

class ApplicationController: NSObject {
    
    let preferencesWindowController = PreferencesWindowController(preferencesManager: .shared, biometricKeychain: .shared)
    let applicationWindowController = ApplicationWindowController(preferencesManager: .shared, biometricKeychain: .shared)
    
    @objc func showPreferences() {
        preferencesWindowController.showWindow()
    }
    
    @objc func lock() {
        applicationWindowController.lock()
    }
    
    @objc func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        switch item.action {
        case #selector(lock):
            return applicationWindowController.isLockable
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
