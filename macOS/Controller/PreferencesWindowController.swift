import AppKit
import SwiftUI

class PreferencesWindowController: NSObject {
    
    private var window: NSWindow?
    private let preferencesStore: PreferencesStore
    
    init(preferencesStore: PreferencesStore) {
        self.preferencesStore = preferencesStore
        
        super.init()
    }
    
    func showWindow() {
        if let window = window {
            window.makeKeyAndOrderFront(nil)
            return
        }
        
        let context = PreferencesModelContext(store: preferencesStore)
        let preferencesModel = PreferencesModel(context: context)
        let preferencesView = PreferencesView(model: preferencesModel)
        
        let window = NSWindow(contentRect: .zero, styleMask: .preferencesWindow, backing: .buffered, defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.setFrameAutosaveName(.preferencesWindowFrameAutosaveName)
        window.contentView = NSHostingView(rootView: preferencesView)
        window.makeKeyAndOrderFront(nil)
        window.delegate = self
        
        self.window = window
    }
    
}

extension PreferencesWindowController: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        window = nil
    }
    
}

private extension NSWindow.StyleMask {
    
    static let preferencesWindow: Self = [
        .titled,
        .closable,
    ]
    
}

private extension String {
    
    static let preferencesWindowFrameAutosaveName = "PreferencesWindow"
    
}