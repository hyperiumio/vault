import Foundation

@MainActor
class StoreSettingsState: ObservableObject {
    
    let storeInfoSettingsState: StoreInfoSettingsState
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.storeInfoSettingsState = StoreInfoSettingsState(service: service)
        self.service = service
    }
    
}
