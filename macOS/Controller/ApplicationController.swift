import AppKit
import Combine
import Preferences

class ApplicationController: NSObject, NSApplicationDelegate {
    
    var applicationWindowController: ApplicationWindowController?
    var preferencesWindowController: PreferencesWindowController?
    var contentModelContext: ContentModelContext?
    
    private var launchStateSubscription: AnyCancellable?
    
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
                
                let preferencesManager = PreferencesManager(userDefaults: .standard)
                let contentModelContext = ContentModelContext(masterKeyUrl: .masterKey, vaultUrl: .vault, preferencesManager: preferencesManager)
                let contentModel = ContentModel(initialState: initialState, context: contentModelContext)
                let contentView = ContentView(model: contentModel)
                let applicationWindowController = ApplicationWindowController(contentView: contentView)
                applicationWindowController.showWindow()
                
                let preferencesWindowController = PreferencesWindowController(preferencesManager: preferencesManager)

                self.applicationWindowController = applicationWindowController
                self.preferencesWindowController = preferencesWindowController
                self.contentModelContext = contentModelContext
                self.launchStateSubscription = nil
            }
    }
    
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
