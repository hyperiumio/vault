import Combine
import Crypto
import Preferences
import Store
import SwiftUI
import UIKit

class ApplicationWindowController {
    
    private let preferencesManager: PreferencesManager
    private let contentModelContext: ContentModelContext
    private let window = UIWindow()
    
    private var launchStateSubscription: AnyCancellable?
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.preferencesManager = preferencesManager
        self.contentModelContext = ContentModelContext(preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func load() {
        guard let activeVaultIdentifier = preferencesManager.preferences.activeVaultIdentifier else {
            let contentModel = ContentModel(setupWithVaultDirectory: .vaultDirectory, context: contentModelContext)
            let contentView = ContentView(model: contentModel)
            window.rootViewController = UIHostingController(rootView: contentView)
            window.makeKeyAndVisible()
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
                
                self.window.rootViewController = UIHostingController(rootView: contentView)
                self.window.makeKeyAndVisible()
                self.launchStateSubscription = nil
            }
    }
    
}

private extension URL {
    
    static var vaultDirectory: URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(Bundle.main.bundleIdentifier!, isDirectory: true).appendingPathComponent("vault", isDirectory: true)
    }
    
}
