import Collection
import Foundation

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published var biometryType: BiometryType?
    @Published private(set) var status = Status.locked
    
    private let inputs = Queue<Input>()
    
    init(service: AppServiceProtocol) {
        Task {
            for await input in AsyncStream(unfolding: inputs.dequeue) {
                switch input {
                case .fetchKeychainAvailability:
                    biometryType = await service.availableBiometry
                case let .unlockWithPassword(password):
                    do {
                        status = .unlocking
                        try await service.unlockWithPassword(password)
                        status = .unlocked
                    } catch {
                        status = .loadingMasterKeyFailed
                    }
                case .unlockWithBiometry:
                    do {
                        status = .unlocking
                        try await service.unlockWithBiometry()
                        status = .unlocked
                    } catch {
                        status = .loadingMasterKeyFailed
                    }
                }
            }
        }
    }
    
    var inputDisabled: Bool {
        status != .locked
    }
    
    func fetchKeychainAvailability() {
        Task {
            await inputs.enqueue(.fetchKeychainAvailability)
        }
    }
    
    func unlockWithPassword() {
        Task {
            let input = Input.unlockWithPassword(password: password)
            await inputs.enqueue(input)
        }
    }
    
    func unlockWihtBiometry() {
        Task {
            await inputs.enqueue(.unlockWithBiometry)
        }
    }
    
}

extension LockedState {
    
    enum Status {
        
        case locked
        case unlocking
        case unlocked
        case wrongPassword
        case loadingMasterKeyFailed
        
    }
    
    enum Input {
        
        case fetchKeychainAvailability
        case unlockWithPassword(password: String)
        case unlockWithBiometry
        
    }
    
}
