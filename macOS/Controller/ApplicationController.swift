import AppKit

class ApplicationController: NSObject, NSApplicationDelegate {
    
    let contentWindowController: ContentWindowController
    
    override init() {
        let contentModel = ContentModel(masterKeyUrl: .masterKey, vaultUrl: .vault)
        let contentView = ContentView(model: contentModel)
        let contentWindowController = ContentWindowController(contentView: contentView)
        
        self.contentWindowController = contentWindowController
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        contentWindowController.showWindow()
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
