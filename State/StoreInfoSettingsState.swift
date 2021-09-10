import Foundation

@MainActor
class StoreInfoSettingsState: ObservableObject {
    
    @Published private(set) var status = Status.initialized
    
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    func load() {
        if case .loading = status {
            return
        }
        
        status = .loading
        
        Task {
            do {
                let info = try await service.loadStoreInfo()
                status = .loaded(info)
            } catch {
                status = .loadingDidFail
            }
        }
    }
    
}

extension StoreInfoSettingsState {
    
    enum Status {
        
        case initialized
        case loading
        case loaded(AppServiceStoreInfo)
        case loadingDidFail
        
    }
    
}
