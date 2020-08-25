import Combine
import Crypto
import Foundation
import Store
import Preferences
import Sort

protocol AppModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    typealias State = AppState<BootstrapModel, SetupModel, LockedModel, UnlockedModel>
    
    var state: State { get }
    
}

enum AppState<BootstrapModel, SetupModel, LockedModel, UnlockedModel> {
    
    case bootstrap(BootstrapModel)
    case setup(SetupModel)
    case locked(LockedModel)
    case unlocked(UnlockedModel)
    
}

class AppModel<BootstrapModel, SetupModel, LockedModel, UnlockedModel>: AppModelRepresentable where BootstrapModel: BootstrapModelRepresentable, SetupModel: SetupModelRepresentable, LockedModel: LockedModelRepresentable, UnlockedModel: UnlockedModelRepresentable {
    
    @Published private(set) var state: State
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        let model = BootstrapModel(preferencesManager: preferencesManager)

        self.state = .bootstrap(model)
        
        model.didBootstrap
            .map { appState in
                switch appState {
                case .setup(let url):
                    let model = SetupModel(vaultContainerDirectory: url, preferencesManager: preferencesManager)
                    model.done
                        .map { vault in
                            UnlockedModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
                        }
                        .map { model in
                            .unlocked(model)
                        }
                        .assign(to: &self.$state)
                    return .setup(model)
                case .locked(let url):
                    let model = LockedModel(vaultDirectory: url, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
                    model.done
                        .map { vault in
                            UnlockedModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
                        }
                        .map { model in
                            .unlocked(model)
                        }
                        .assign(to: &self.$state)
                    return .locked(model)
                }
            }
            .assign(to: &$state)
        
        model.load()
    }
    
    func lock() {

    }
    
}
