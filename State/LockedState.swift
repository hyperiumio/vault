import Common
import Foundation

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published var biometryType: BiometryType?
    @Published private(set) var status = Status.locked
    
    private let yield = AsyncValue<Void>()
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    var done: Void {
        get async {
            await yield.value
        }
    }
    
    var inputDisabled: Bool {
        status != .locked
    }
    
    func fetchKeychainAvailability() async {
        biometryType = await dependency.unlockService.availableBiometry
    }
    
    func unlock(with login: Login) async {
        status = .unlocking
        
        do {
            switch login {
            case .password:
                try await dependency.unlockService.unlockWithPassword(password)
            case .biometry:
                try await dependency.unlockService.unlockWithBiometry()
            }
        } catch {
            status = .wrongPassword
        }
    }
    
}

extension LockedState {
    
    enum Login {
        
        case password
        case biometry
        
    }
    
    enum Status {
        
        case locked
        case unlocking
        case wrongPassword
        case missingMasterKey
        
    }
    
}
