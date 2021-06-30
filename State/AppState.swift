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
        let setupState = SetupState(service: service, yield: presentUnlockedState)
        status = .setup(state: setupState)
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
