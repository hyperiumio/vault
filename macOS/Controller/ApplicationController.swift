import AppKit

class ApplicationController: NSObject, NSApplicationDelegate {
    
    let contentWindowController: ContentWindowController
    
    override init() {
        let setupModel = SetupModel(vaultUrl: .vaultUrl)
        let setupView = SetupView(model: setupModel)
        let contentWindowController = ContentWindowController(contentView: setupView)
        
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
