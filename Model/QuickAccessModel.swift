import Combine
import Foundation

protocol QuickAccessModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype CredentialProviderModel: CredentialProviderModelRepresentable
    
    typealias State = QuickAccessModelState<LockedModel, CredentialProviderModel>
    
    var state: State { get }
    
}

protocol QuickAccessModelDependency {
    
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype CredentialProviderModel: CredentialProviderModelRepresentable
    
    func lockedModel(vaultID: UUID) -> LockedModel
    func credentialProviderModel(vault: Vault) -> CredentialProviderModel
    
}

enum QuickAccessModelState<Locked, Unlocked> {
    
    case locked(Locked)
    case unlocked(Unlocked)
    
}

class QuickAccessModel<Dependency>: QuickAccessModelRepresentable where Dependency: QuickAccessModelDependency {
    
    typealias LockedModel = Dependency.LockedModel
    typealias CredentialProviderModel = Dependency.CredentialProviderModel
    
    @Published var state: State
    
    init(dependency: Dependency, vaultID: UUID) {
        let lockedModel = dependency.lockedModel(vaultID: vaultID)
        
        self.state = .locked(lockedModel)
        
        lockedModel.done
            .map(dependency.credentialProviderModel)
            .map(QuickAccessModelState.unlocked)
            .assign(to: &$state)
    }
    
}
