import Foundation

@MainActor
class StoreInfoSettingsState: ObservableObject {
    
    let storeInfo: AppServiceStoreInfo
    
    init(service: AppServiceProtocol) async throws {
        self.storeInfo = try await service.loadStoreInfo()
    }
    
}
