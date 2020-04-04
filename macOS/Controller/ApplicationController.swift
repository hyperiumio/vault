import AppKit
import Combine

class ApplicationController: NSObject, NSApplicationDelegate {
    
    let contentWindowController = ContentWindowController()
    
    private var launchStateSubscription: AnyCancellable?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        launchStateSubscription = FileExistsPublisher(url: .masterKey)
            .receive(on: DispatchQueue.main)
            .sink { [contentWindowController] masterKeyExists in
                let initialState = masterKeyExists ? ContentModel.InitialState.locked : ContentModel.InitialState.setup
                let contentModel = ContentModel(initialState: initialState, masterKeyUrl: .masterKey, vaultUrl: .vault)
                let contentView = ContentView(model: contentModel)
                contentWindowController.showWindow(contentView: contentView)
            }
    }
    
    @objc func showPreferences() {
        
    }
    
    @objc func lock() {
        
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
