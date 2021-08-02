import Foundation
import Shim

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published var biometryType: BiometryType?
    @Published private(set) var status = Status.locked
    
    private let service: AppServiceProtocol
    private var unlockContinuation: CheckedContinuation<Void, Never>?
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    var unlocked: Void {
        get async {
            await withCheckedContinuation { continuation in
                unlockContinuation = continuation
            }
        }
    }
    
    var inputDisabled: Bool {
        status != .locked
    }
    
    func fetchKeychainAvailability() async {
        biometryType = await service.availableBiometry
    }
    
    func unlock(with login: Login) async {
        guard status != .unlocking, status != .unlocked else {
            return
        }
        
        status = .unlocking
        
        do {
            switch login {
            case .password:
                try await service.unlockWithPassword(password)
            case .biometry:
                try await service.unlockWithBiometry()
            }
            status = .unlocked
            unlockContinuation?.resume()
        } catch CryptoError.wrongPassword {
            status = .wrongPassword
        } catch {
            status = .loadingMasterKeyFailed
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
        case unlocked
        case wrongPassword
        case loadingMasterKeyFailed
        
    }
    
}
