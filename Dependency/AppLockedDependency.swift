import Crypto
import Foundation
import Persistence
import Preferences

@MainActor
struct AppLockedDependency {
    
    private let containerDirectory: URL
    private let preferences: Preferences
    private let keychain: Keychain
    
    init() {
        let containerDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent(.vaults, isDirectory: true)
        let userDefaults = UserDefaults(suiteName: .appGroup)!
        let preferences = Preferences(using: userDefaults)
        let keychain = Keychain(accessGroup: .appGroup)
        
        self.containerDirectory = containerDirectory
        self.preferences = preferences
        self.keychain = keychain
    }
    
}

extension AppLockedDependency: AppModelDependency {
    
    func bootstrapModel() -> BootstrapModel {
        BootstrapModel(containerDirectory: containerDirectory, preferences: preferences)
    }
    
    func setupModel() -> SetupModel<Self> {
        SetupModel(dependency: self, keychain: keychain)
    }
    
    func lockedMainModel(store: Store) -> MainModel<Self> {
        let lockedModel = self.lockedModel(store: store)
        let state = MainModel.State.locked(model: lockedModel)
        return MainModel(dependency: self, state: state)
    }
    
    func unlockedMainModel(store: Store, derivedKey: DerivedKey, masterKey: MasterKey) -> MainModel<Self> {
        let unlockedModel = self.unlockedModel(store: store, derivedKey: derivedKey, masterKey: masterKey, itemIndex: [:])
        let state = MainModel.State.unlocked(model: unlockedModel)
        return MainModel(dependency: self, state: state)
    }
    
}

extension AppLockedDependency: SetupModelDependency {
    
    func choosePasswordModel() -> ChoosePasswordModel {
        ChoosePasswordModel()
    }
    
    func repeatPasswordModel(password: String) -> RepeatPasswordModel {
        RepeatPasswordModel(password: password)
    }
    
    func enabledBiometricUnlockModel(password: String, biometryType: Keychain.BiometryType) -> EnableBiometricUnlockModel {
        EnableBiometricUnlockModel(password: password, biometryType: biometryType)
    }
    
    func completeSetupModel(password: String, biometricUnlockEnabled: Bool) -> CompleteSetupModel {
        CompleteSetupModel(password: password, biometricUnlockEnabled: biometricUnlockEnabled, containerDirectory: containerDirectory, preferences: preferences, keychain: keychain)
    }
    
}

extension AppLockedDependency: MainModelDependency {
    
    func lockedModel(store: Store) -> LockedModel {
        LockedModel(store: store, preferences: preferences, keychain: keychain)
    }
    
    func unlockedModel(store: Store, derivedKey: DerivedKey, masterKey: MasterKey, itemIndex: [StoreItemLocator: StoreItemInfo]) -> UnlockedModel<AppUnlockedDependency> {
        let dependency = AppUnlockedDependency(store: store, preferences: preferences, keychain: keychain, derivedKey: derivedKey, masterKey: masterKey)
        return UnlockedModel(store: store, itemIndex: itemIndex, dependency: dependency)
    }
    
}

private extension String {
    
    static var vaults: Self { "Vaults" }
    
    #if os(iOS)
    static var appGroup: Self { "group.io.hyperium.vault" }
    #endif

    #if os(macOS)
    static var appGroup: Self { "HX3QTQLX65.io.hyperium.vault" }
    #endif
    
}
