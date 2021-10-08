import Collection
import Foundation

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published private(set) var status = Status.locked
    @Published private(set) var unlockAvailability: AppServiceUnlockAvailability?
    private let infoData: AsyncThrowingStream<Data, Error>
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.infoData = service.loadInfoData()
        self.service = service
        
        Task {
            self.unlockAvailability = try await service.unlockAvailability
        }
    }
    
    func presentUnlockFailed() {
        status = .unlockFailed
    }
    
    func dismissUnlockFailed() {
        status = .locked
    }
    
    func unlock(with login: Login) {
        guard case .locked = status else {
            return
        }
        
        status = .unlocking
        Task {
            do {
                switch login {
                case .password:
                    try await service.unlockWithPassword(password)
                case .biometry:
                    try await service.unlockWithBiometry()
                }

                status = .unlocked
            } catch {
                status = .unlockFailed
            }
        }
    }
    
}

extension LockedState {
    
    enum Status {
        
        case locked
        case unlocking
        case unlocked
        case unlockFailed
        
    }
    
    enum Login {
        
        case password
        case biometry
        
    }
    
}
