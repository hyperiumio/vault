import Combine
import Storage
import Crypto
import Foundation

protocol MainModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    typealias State = MainModelState<LockedModel, UnlockedModel>
    
    var state: State { get }
    
}

protocol MainModelDependency {
    
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    func lockedModel(store: Store) -> LockedModel
    func unlockedModel(store: Store, derivedKey: DerivedKey, masterKey: MasterKey, itemIndex: [Store.ItemLocator: StoreItemInfo]) -> UnlockedModel
    
}

enum MainModelState<Locked, Unlocked> {
    
    case locked(model: Locked, store: Store, userBiometricUnlock: Bool)
    case unlocked(model: Unlocked, store: Store)
    
}

class MainModel<Dependency>: MainModelRepresentable where Dependency: MainModelDependency {
    
    typealias LockedModel = Dependency.LockedModel
    typealias UnlockedModel = Dependency.UnlockedModel
    
    @Published var state: State
    
    private let dependency: Dependency
    
    init(dependency: Dependency, state: State) {
        
        func statePublisher(from state: State) -> AnyPublisher<State, Never> {
            switch state {
            case .locked(let model, let store, _):
                let encryptedItemIndexLoaded = store.loadItems() { context -> (Store.ItemLocator, SecureDataHeader, SecureDataMessage) in
                    let header = try SecureDataHeader { range in
                        try context.bytes(in: range)
                    }
                    let nonceDataRange = header.elements[.infoIndex].nonceRange
                    let ciphertextRange = header.elements[.infoIndex].ciphertextRange
                    let nonce = try context.bytes(in: nonceDataRange)
                    let ciphertext = try context.bytes(in: ciphertextRange)
                    let tag = header.elements[.infoIndex].tag
                    let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
                    return (context.itemLocator, header, message)
                }
                .assertNoFailure()
                .collect()
                
                return Publishers.Zip(encryptedItemIndexLoaded, model.done)
                    .tryMap { encryptedItemIndex, keys in
                        let (derivedKey, masterKey) = keys
                        let itemIndexValues = try encryptedItemIndex.map { itemLocator, header, message in
                            let messageKey = try header.unwrapKey(with: masterKey)
                            let encodedItemInfo = try message.decrypt(using: messageKey)
                            let storeItemInfo = try StoreItemInfo(from: encodedItemInfo)
                            return (itemLocator, storeItemInfo)
                        } as [(Store.ItemLocator, StoreItemInfo)]
                        let itemIndex = Dictionary(uniqueKeysWithValues: itemIndexValues)
                        let model = dependency.unlockedModel(store: store, derivedKey: derivedKey, masterKey: masterKey, itemIndex: itemIndex)
                        return MainModelState.unlocked(model: model, store: store)
                    }
                    .assertNoFailure()
                    .eraseToAnyPublisher()
            case .unlocked(let model, let store):
                return model.lockRequest
                    .map { enableBiometricUnlock in
                        let model = dependency.lockedModel(store: store)
                        return .locked(model: model, store: store, userBiometricUnlock: enableBiometricUnlock)
                    }
                    .eraseToAnyPublisher()
            }
        }
        
        self.state = state
        self.dependency = dependency
        
        statePublisher(from: state)
            .assign(to: &$state)
        
        $state
            .flatMap(statePublisher)
            .assign(to: &$state)
    }
    
    func lock() {
        switch state {
        case .locked:
            return
        case .unlocked(_, let store):
            let lockedModel = dependency.lockedModel(store: store)
            state = .locked(model: lockedModel, store: store, userBiometricUnlock: false)
        }
    }
    
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let primarySecureItemIndex = 1
    static let secondarySecureItemIndex = 2
    
}

#if DEBUG
class MainModelStub: MainModelRepresentable {
    
    typealias LockedModel = LockedModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
    func lock() {}
    
}
#endif
