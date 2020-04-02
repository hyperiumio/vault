import AppKit

class ApplicationController: NSObject, NSApplicationDelegate {
    
    let contentWindowController: ContentWindowController
    
    override init() {
        let contentModel = ContentModel(vaultUrl: .vaultUrl)
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
    
    static var vaultUrl: URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("Vault", isDirectory: true)
    }
    
}
