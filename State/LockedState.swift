import Crypto
import Foundation

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published private(set) var status = Status.locked
    @Published var keychainAvailablility: KeychainAvailability?
    
    private let storeID: UUID
    private let service: Service
    private let yield: Yield
    private let masterKeyContainerLoadingTask: Task.Handle<Data, Never>
    
    init(storeID: UUID, service: Service, yield: @escaping Yield) {
        self.storeID = storeID
        self.service = service
        self.yield = yield
        self.masterKeyContainerLoadingTask = detach {
            await service.store.masterKeyContainer
        }
    }
    
    var inputDisabled: Bool {
        status != .locked
    }
    
    func fetchKeychainAvailability() async {
        keychainAvailablility = await service.security.keychainAvailability
    }
    
    func loginWithPassword() async {
        status = .unlocking
        
        do {
            let derivedKeyContainer = await service.store.derivedKeyContainer
            let masterKeyContainer = await masterKeyContainerLoadingTask.get()
            let publicArguments = try DerivedKey.PublicArguments(from: derivedKeyContainer)
            let derivedKey = try DerivedKey(from: password, with: publicArguments)
            let masterKey = try MasterKey(from: masterKeyContainer, using: derivedKey)
            yield(derivedKey, masterKey, storeID)
            status = .unlocked
        } catch {
            status = .wrongPassword
        }
    }
    
    func loginWithBiometry() async {
        status = .unlocking
        
        do {
            let derivedKey = await service.security.derivedKey
            let masterKeyContainer = await masterKeyContainerLoadingTask.get()
            let masterKey = try MasterKey(from: masterKeyContainer, using: derivedKey)
            yield(derivedKey, masterKey, storeID)
            status = .unlocked
        } catch {
            status = .wrongPassword
        }
    }
    
}

extension LockedState {
    
    typealias Yield = @MainActor (_ derivedKey: DerivedKey, _ masterKey: MasterKey, _ storeID: UUID) -> Void
    typealias BiometryType = Crypto.BiometryType
    
    enum Status {
        
        case locked
        case unlocking
        case unlocked
        case wrongPassword
    }
    
}
