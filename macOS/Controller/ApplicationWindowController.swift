import AppKit
import Combine
import Crypto
import Preferences
import Store
import SwiftUI

class ApplicationWindowController: NSObject {
    
    var isLockable: Bool {
        contentModelContext.responder?.isLockable ?? false
    }
    
    var canShowPreferences: Bool {
        contentModelContext.responder?.canShowPreferences ?? false
    }
    
    private let preferencesManager: PreferencesManager
    private let contentModelContext: ContentModelContext
    private let window: NSWindow
    
    private var launchStateSubscription: AnyCancellable?
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.preferencesManager = preferencesManager
        self.contentModelContext = ContentModelContext(preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        self.window = NSWindow(contentRect: .zero, styleMask: .applicationWindow, backing: .buffered, defer: false)
        
        super.init()
        
        window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
        window.center()
        window.setFrameAutosaveName(.applicationWindowFrameAutosaveName)
        window.delegate = self
    }
    
    func load() {
        guard let activeVaultIdentifier = preferencesManager.preferences.activeVaultIdentifier else {
            let contentModel = ContentModel(setupWithVaultDirectory: .vaultDirectory, context: contentModelContext)
            let contentView = ContentView(model: contentModel)
            window.contentView = NSHostingView(rootView: contentView)
            window.makeKeyAndOrderFront(nil)
            return
        }
        
        launchStateSubscription = Vault<SecureDataCryptor>.vaultLocation(for: activeVaultIdentifier, inDirectory: .vaultDirectory)
            .assertNoFailure()
            .receive(on: DispatchQueue.main)
            .sink { [weak self, contentModelContext] vaultLocation in
                guard let self = self else {
                    return
                }
                
                let contentModel = vaultLocation.map { vaultLocation in
                    return ContentModel(lockedWithVaultLocation: vaultLocation, context: contentModelContext)
                } ?? ContentModel(setupWithVaultDirectory: .vaultDirectory, context: contentModelContext)
                let contentView = ContentView(model: contentModel)
                
                self.window.contentView = NSHostingView(rootView: contentView)
                self.window.makeKeyAndOrderFront(nil)
                self.launchStateSubscription = nil
            }
    }
    
    func lock() {
        contentModelContext.responder?.lock()
    }
    
    func showPreferences() {
        contentModelContext.responder?.showPreferences()
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

private extension URL {
    
    static var vaultDirectory: URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(Bundle.main.bundleIdentifier!, isDirectory: true).appendingPathComponent("vault", isDirectory: true)
    }
    
}
