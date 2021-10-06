import Collection
import Foundation

@MainActor
class SecuritySettingsState: ObservableObject {
    
    @Published var isTouchIDUnlockEnabled: Bool {
        didSet {
            Task {
                await service.save(touchIDUnlock: isTouchIDUnlockEnabled)
            }
        }
    }

    @Published var isFaceIDUnlockEnabled: Bool {
        didSet {
            Task {
                await service.save(faceIDUnlock: isFaceIDUnlockEnabled)
            }
        }
    }
    
    @Published var isWatchUnlockEnabled: Bool {
        didSet {
            Task {
                await service.save(watchUnlock: isWatchUnlockEnabled)
            }
        }
    }
    
    @Published var hidePasswords: Bool {
        didSet {
            Task {
                await service.save(hidePasswords: hidePasswords)
            }
        }
    }
    
    @Published var clearPasteboard: Bool {
        didSet {
            Task {
                await service.save(clearPasteboard: clearPasteboard)
            }
        }
    }
    
    @Published var status = Status.input

    let recoveryKeySettingsState: RecoveryKeySettingsState
    let unlockAvailability: AppServiceUnlockAvailability
    private let service: AppServiceProtocol
    private let inputBuffer = AsyncQueue<Input>()
    
    init(unlockAvailability: AppServiceUnlockAvailability, defaults: AppServiceDefaults, service: AppServiceProtocol) {
        self.isTouchIDUnlockEnabled = defaults.touchIDUnlock
        self.isFaceIDUnlockEnabled = defaults.faceIDUnlock
        self.isWatchUnlockEnabled = defaults.watchUnlock
        self.hidePasswords = defaults.hidePasswords
        self.clearPasteboard = defaults.clearPasteboard
        self.unlockAvailability = unlockAvailability
        self.recoveryKeySettingsState = RecoveryKeySettingsState(service: service)
        self.service = service
        
        let serviceInputs = service.events.compactMap(Input.init)
        inputBuffer.enqueue(serviceInputs)
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
                switch input {
                case .defaultsDidChange:
                    break
                }
            }
        }
    }
    
    var isExtendedUnlockAvailable: Bool {
        isTouchIDUnlockEnabled || isFaceIDUnlockEnabled || isWatchUnlockEnabled
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
        
        init?(_ event: AppServiceEvent) {
            switch event {
            case .storeDidChange:
                return nil
            case .defaultsDidChange:
                self = .defaultsDidChange
            }
        }
        
    }
    
}
