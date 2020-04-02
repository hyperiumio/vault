import AppKit

class ApplicationController: NSObject, NSApplicationDelegate {
    
    let contentWindowController = ContentWindowController()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        contentWindowController.showWindow()
    }
    
}
