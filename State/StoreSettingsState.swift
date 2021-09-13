import Foundation

@MainActor
class StoreSettingsState: ObservableObject {
    
    @Published private(set) var status = Status.input
    let storeInfoSettingsState: StoreInfoSettingsState
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.storeInfoSettingsState = StoreInfoSettingsState(service: service)
        self.service = service
    }
    
    func deleteAllData() {
        guard status == .input else {
            return
        }
        
        status = .processing
        
        Task {
            do {
                try await service.deleteAllData()
                status = .input
            } catch {
                status = .deleteAllDataDidFail
            }
        }
    }
    
}

extension StoreSettingsState {
    
    enum Status {
        
        case input
        case processing
        case deleteAllDataDidFail
        
    }
    
}
