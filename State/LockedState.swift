import Event
import Foundation
import Sort

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published private(set) var status = Status.locked
    @Published private(set) var biometry: AppServiceBiometry?
    private let infoData: AsyncThrowingStream<Data, Error>
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.infoData = service.loadInfoData()
        self.service = service
        
        Task {
            self.biometry = await service.availableBiometry
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
                
                let states = service.decryptStoreItemInfos(from: infoData).map { [service] info in
                    StoreItemDetailState(storeItemInfo: info, service: service)
                }
                let collation = try await AlphabeticCollation<StoreItemDetailState>(from: states, grouped: \.name)
                status = .unlocked(collation: collation)
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
        case unlocked(collation: AlphabeticCollation<StoreItemDetailState>)
        case unlockFailed
        
    }
    
    enum Login {
        
        case password
        case biometry
        
    }
    
}
