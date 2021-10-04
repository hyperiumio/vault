import Collection
import Foundation

@MainActor
class SecuritySettingsState: ObservableObject {
    
    @Published var status = Status.input
    
    @Published var isBiometricUnlockEnabled: Bool {
        didSet {
            Task {

            }
        }
    }
    
    @Published var isWatchUnlockEnabled: Bool {
        didSet {
            Task {
                
            }
        }
    }
    
    @Published var hidePasswords: Bool {
        didSet {
            Task {
                
            }
        }
    }
    
    @Published var clearPasteboard: Bool {
        didSet {
            Task {
                
            }
        }
    }
    
    @Published private(set) var extendedUnlock: ExtendedUnlock?
    let recoveryKeySettingsState: RecoveryKeySettingsState
    private let service: AppServiceProtocol
    private let inputBuffer = AsyncQueue<Input>()
    
    init(service: AppServiceProtocol) {
        self.isBiometricUnlockEnabled = true
        self.isWatchUnlockEnabled = true
        self.hidePasswords = true
        self.clearPasteboard = true
        self.recoveryKeySettingsState = RecoveryKeySettingsState(service: service)
        self.service = service
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
                switch input {
                case .defaultsDidChange:
                    break
                }
            }
        }
    }
    
    func load() {
        status = .loading
        Task {
            do {
                let biometryAvailability = try await service.availableBiometry
                let watchAvailablility = true
                extendedUnlock = ExtendedUnlock(biometry: biometryAvailability, watch: watchAvailablility)
                status = .input
            } catch {
                status = .failure(.fail)
            }
        }
    }
    
}

extension SecuritySettingsState {
    
    enum Status {
        
        case input
        case loading
        case failure(Failure)
        
    }
    
    enum Failure: Error {
        
        case fail
        
    }
    
    enum Input {
        
        case defaultsDidChange
        
    }
    
    struct ExtendedUnlock {
        
        let biometry: AppServiceBiometry?
        let watch: Bool
        
    }
    
}
