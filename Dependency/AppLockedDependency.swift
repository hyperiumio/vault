import Crypto
import Foundation
import Preferences

struct AppLockedDependency {
    
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(preferences: Preferences, keychain: Keychain) {
        self.preferences = preferences
        self.keychain = keychain
    }
    
}

extension AppLockedDependency: AppModelDependency {
    
    func bootstrapModel() -> BootstrapModel {
        BootstrapModel(preferences: preferences)
    }
    
    func setupModel(in vaultContainerDirectory: URL) -> SetupModel {
        SetupModel(vaultContainerDirectory: vaultContainerDirectory, preferences: preferences, keychain: keychain)
    }
    
    func mainModel(vaultDirectory: URL) -> MainModel<Self> {
        MainModel(dependency: self, vaultDirectory: vaultDirectory)
    }
    
    func mainModel(vaultDirectory: URL, vault: Vault) -> MainModel<Self> {
        MainModel(dependency: self, vaultDirectory: vaultDirectory, vault: vault)
    }
    
}

extension AppLockedDependency: MainModelDependency {
    
    func lockedModel(vaultDirectory: URL) -> LockedModel {
        LockedModel(vaultDirectory: vaultDirectory, preferences: preferences, keychain: keychain)
    }
    
    func unlockedModel(vault: Vault) -> UnlockedModel<AppUnlockedDependency> {
        let dependency = AppUnlockedDependency(vault: vault, preferences: preferences, keychain: keychain)
        return UnlockedModel(vault: vault, dependency: dependency)
    }
    
}
