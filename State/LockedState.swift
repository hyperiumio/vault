import Event
import Foundation

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published var biometryType: BiometryType?
    @Published private(set) var status = Status.locked
    
    private let inputBuffer = EventBuffer<Input>()
    
    init(service: AppServiceProtocol) {
        Task {
            for await input in inputBuffer.events {
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
        inputBuffer.enqueue(.fetchKeychainAvailability)
    }
    
    func unlockWithPassword() {
        let input = Input.unlockWithPassword(password: password)
        inputBuffer.enqueue(input)
    }
    
    func unlockWihtBiometry() {
        inputBuffer.enqueue(.unlockWithBiometry)
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
