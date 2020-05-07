import AppKit
import Combine
import SwiftUI

class ApplicationWindowController: NSObject {
    
    private let window: NSWindow
    
    override init() {
        self.window = NSWindow(contentRect: .zero, styleMask: .applicationWindow, backing: .buffered, defer: false)
        
        super.init()
        
        window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
        window.center()
        window.setFrameAutosaveName(.applicationWindowFrameAutosaveName)
        window.delegate = self
    }
    
    func showWindow<Content>(contentView: Content) where Content: View {
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
    
}

extension ApplicationWindowController: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(self)
    }
    
}

private extension NSWindow.StyleMask {
    
    static let applicationWindow: Self = [
        .titled,
        .closable,
        .miniaturizable,
        .resizable,
        .fullSizeContentView
    ]
    
}

private extension String {
    
    static let applicationWindowFrameAutosaveName = "ApplicationWindow"
    
}
