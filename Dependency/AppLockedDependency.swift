import Crypto
import Foundation
import Model
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

extension AppLockedDependency: AppStateDependency {
    
    func bootstrapState() -> BootstrapState {
        BootstrapState(containerDirectory: containerDirectory, preferences: preferences)
    }
    
    func setupState() -> SetupState<Self> {
        SetupState(dependency: self, keychain: keychain)
    }
    
    func lockedMainState(store: Store) -> MainState<Self> {
        let lockedState = self.lockedState(store: store)
        let state = MainState.State.locked(state: lockedState)
        return MainState(dependency: self, state: state)
    }
    
    func unlockedMainState(store: Store, derivedKey: DerivedKey, masterKey: MasterKey) -> MainState<Self> {
        let unlockedState = self.unlockedState(store: store, derivedKey: derivedKey, masterKey: masterKey, itemIndex: [:])
        let state = MainState.State.unlocked(state: unlockedState)
        return MainState(dependency: self, state: state)
    }
    
}

extension AppLockedDependency: SetupStateDependency {
    
    func choosePasswordState() -> ChoosePasswordState {
        ChoosePasswordState()
    }
    
    func repeatPasswordState(password: String) -> RepeatPasswordState {
        RepeatPasswordState(password: password)
    }
    
    func enabledBiometricUnlockState(password: String, biometryType: Keychain.BiometryType) -> EnableBiometricUnlockState {
        EnableBiometricUnlockState(password: password, biometryType: biometryType)
    }
    
    func completeSetupState(password: String, biometricUnlockEnabled: Bool) -> CompleteSetupState {
        CompleteSetupState(password: password, biometricUnlockEnabled: biometricUnlockEnabled, containerDirectory: containerDirectory, preferences: preferences, keychain: keychain)
    }
    
}

extension AppLockedDependency: MainStateDependency {
    
    func lockedState(store: Store) -> LockedState {
        LockedState(store: store, preferences: preferences, keychain: keychain)
    }
    
    func unlockedState(store: Store, derivedKey: DerivedKey, masterKey: MasterKey, itemIndex: [StoreItemLocator: StoreItemInfo]) -> UnlockedState<AppUnlockedDependency> {
        let dependency = AppUnlockedDependency(store: store, preferences: preferences, keychain: keychain, derivedKey: derivedKey, masterKey: masterKey)
        return UnlockedState(store: store, itemIndex: itemIndex, dependency: dependency)
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
