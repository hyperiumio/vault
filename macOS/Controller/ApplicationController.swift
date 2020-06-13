import AppKit
import Combine

class ApplicationController: NSObject, NSApplicationDelegate {
    
    var applicationWindowController: ApplicationWindowController?
    var preferencesWindowController: PreferencesWindowController?
    var contentModelContext: ContentModelContext?
    
    private var launchStateSubscription: AnyCancellable?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        launchStateSubscription = LaunchState.publisher(masterKeyUrl: .masterKey)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] launchState in
                guard let self = self else {
                    return
                }
                let initialState = launchState.vaultExists ? ContentModel.InitialState.locked : ContentModel.InitialState.setup
                let contentModelContext = ContentModelContext(masterKeyUrl: .masterKey, vaultUrl: .vault, preferencesManager: launchState.preferencesManager)
                let contentModel = ContentModel(initialState: initialState, context: contentModelContext)
                let contentView = ContentView(model: contentModel)
                let applicationWindowController = ApplicationWindowController(contentView: contentView)
                applicationWindowController.showWindow()
                
                let preferencesWindowController = PreferencesWindowController(preferencesManager: launchState.preferencesManager)

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
