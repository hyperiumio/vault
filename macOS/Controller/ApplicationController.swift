import AppKit
import Combine

class ApplicationController: NSObject, NSApplicationDelegate {
    
    let contentWindowController = ContentWindowController()
    let contentModelContext = ContentModelContext(masterKeyUrl: .masterKey, vaultUrl: .vault)
    
    private var launchStateSubscription: AnyCancellable?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        launchStateSubscription = FileExistsPublisher(url: .masterKey)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] masterKeyExists in
                guard let self = self else {
                    return
                }
                
                let initialState = masterKeyExists ? ContentModel.InitialState.locked : ContentModel.InitialState.setup
                let contentModel = ContentModel(initialState: initialState, context: self.contentModelContext)
                let contentView = ContentView(model: contentModel)
                self.contentWindowController.showWindow(contentView: contentView)
                
                self.launchStateSubscription = nil
            }
    }
    
    @objc func showPreferences() {
        
    }
    
    @objc func lock() {
        contentModelContext.responder?.lock()
    }
    
    @objc func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        switch item.action {
        case #selector(lock):
            return contentModelContext.responder?.isLockable ?? false
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
