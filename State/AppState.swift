import Crypto
import Foundation
import Model
import Preferences

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching
    
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func bootstrap() async {
        if let storeID = await service.defaults.defaults.activeStoreID {
            presentLockedState(storeID: storeID)
        } else {
            presentSetupState()
        }
    }
    
    func presentSetupState() {
        let setupState = SetupState(service: service, yield: presentUnlockedState)
        status = .setup(state: setupState)
    }
    
    func presentLockedState(storeID: UUID) {
        let lockedState = LockedState(storeID: storeID, service: service, yield: presentUnlockedState)
        status = .locked(state: lockedState)
    }
    
    func presentUnlockedState(derivedKey: DerivedKey, masterKey: MasterKey, storeID: UUID) {
        
    }
    
}

extension AppState {
    
    enum Status {
        
        case launching
        case launchingFailed
        case setup(state: SetupState)
        case locked(state: LockedState)
        case unlocked(state: UnlockedState)
        
    }
    
}
