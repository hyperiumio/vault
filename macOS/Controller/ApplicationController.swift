import AppKit
import Combine
import Crypto
import Preferences

class ApplicationController: NSObject {
    
    let preferencesManager = PreferencesManager.shared
    let biometricKeychain = BiometricKeychain.shared
    
    var applicationWindowController: ApplicationWindowController?
    var preferencesWindowController: PreferencesWindowController?
    var contentModelContext: ContentModelContext?
    
    private var launchStateSubscription: AnyCancellable?
    
    @objc func showPreferences() {
        preferencesWindowController?.showWindow()
    }
    
    @objc func lock() {
        contentModelContext?.responder?.lock()
    }
    
    @objc func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        switch item.action {
        case #selector(lock):
            return contentModelContext?.responder?.isLockable ?? false
        default:
            return true
        }
    }
    
}

extension ApplicationController: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        launchStateSubscription = FileManager.default.fileExistsPublisher(url: .masterKey)
            .map { fileExists in
                return (fileExists ? .locked : .setup) as ContentModel.InitialState
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] initialState in
                guard let self = self else {
                    return
                }
                
                let contentModelContext = ContentModelContext(masterKeyUrl: .masterKey, vaultUrl: .vault, preferencesManager: self.preferencesManager, biometricKeychain: self.biometricKeychain)
                let contentModel = ContentModel(initialState: initialState, context: contentModelContext)
                let contentView = ContentView(model: contentModel)
                let applicationWindowController = ApplicationWindowController(contentView: contentView)
                applicationWindowController.showWindow()
                
                let preferencesWindowController = PreferencesWindowController(preferencesManager: .shared, biometricKeychain: .shared)

                self.applicationWindowController = applicationWindowController
                self.preferencesWindowController = preferencesWindowController
                self.contentModelContext = contentModelContext
                self.launchStateSubscription = nil
            }
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        biometricKeychain.invalidateAvailability()
    }
    
}

private extension URL {
    
    static var appData: URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(Bundle.main.bundleIdentifier!, isDirectory: true)
    }
    
    static var masterKey: URL {
        return appData.appendingPathComponent("key", isDirectory: false)
    }

    static var vault: URL {
        return appData.appendingPathComponent("content", isDirectory: true)
    }
    
}
