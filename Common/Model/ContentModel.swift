import Combine
import Crypto
import Foundation
import Store

class ContentModel: ObservableObject {
    
    @Published private(set) var state: State {
        didSet {
            setupStateTransitions()
        }
    }
    
    #if canImport(AppKit)
    private let preferencesWindowController: PreferencesWindowController
    #endif
    
    private let context: ContentModelContext
    private var stateTransitionSubscription: AnyCancellable?
    
    init(setupWithVaultDirectory vaultDirectory: URL, context: ContentModelContext) {
        let model = context.setupModel(vaultDirectory: vaultDirectory)
        self.state = .setup(model)
        self.context = context
        
        #if canImport(AppKit)
        self.preferencesWindowController = PreferencesWindowController(preferencesManager: context.preferencesManager, biometricKeychain: context.biometricKeychain)
        context.responder = self
        #endif
        
        setupStateTransitions()
    }
    
    init(lockedWithVaultLocation vaultLocation: VaultLocation, context: ContentModelContext) {
        let model = context.lockedModel(vaultLocation: vaultLocation)
        self.state = .locked(model)
        self.context = context
        
        #if canImport(AppKit)
        self.preferencesWindowController = PreferencesWindowController(preferencesManager: context.preferencesManager, biometricKeychain: context.biometricKeychain)
        context.responder = self
        #endif
        
        setupStateTransitions()
    }
    
    private func setupStateTransitions() {
        switch state {
        case .setup(let model):
            stateTransitionSubscription = model.didCreateVault
                .receive(on: DispatchQueue.main)
                .sink { [weak self] vault in
                    guard let self = self else {
                        return
                    }
                
                    let model = self.context.unlockedModel(vault: vault)
                    self.state = .unlocked(model)
                }
        case .locked(let model):
            stateTransitionSubscription = model.didOpenVault
                .receive(on: DispatchQueue.main)
                .sink { [weak self] vault in
                    guard let self = self else {
                        return
                    }
                
                    let model = self.context.unlockedModel(vault: vault)
                    self.state = .unlocked(model)
                }
        case .unlocked:
            stateTransitionSubscription = nil
            return
        }
    }
    
}

#if canImport(AppKit)
extension ContentModel: ContentModelContextResponder {
    
    var canShowPreferences: Bool {
        switch state {
        case .setup, .locked:
            return false
        case .unlocked:
            return true
        }
    }
    
    var isLockable: Bool {
        switch state {
        case .setup, .locked:
            return false
        case .unlocked:
            return true
        }
    }
    
    func lock() {
        switch state {
        case .unlocked(let model):
            let model = context.lockedModel(vaultLocation: model.vault.location)
            state = .locked(model)
        case .setup, .locked:
           return
        }
    }
    
    func showPreferences() {
        switch state {
        case .unlocked(let model):
            preferencesWindowController.showWindow(using: model.vault)
        case .setup, .locked:
           return
        }
    }
    
}
#endif

extension ContentModel {
    
    enum State {
        
        case setup(SetupModel)
        case locked(LockedModel)
        case unlocked(UnlockedModel)
        
    }
    
}
