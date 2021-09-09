import Foundation

@MainActor
class SettingsState: ObservableObject, Identifiable {
    
    let securitySettingsState: SecuritySettingsState
    let storeSettingsState: StoreSettingsState
    let syncSettingsState: SyncSettingsState
    
    init(service: AppServiceProtocol) {
        self.securitySettingsState = SecuritySettingsState(service: service)
        self.storeSettingsState = StoreSettingsState(service: service)
        self.syncSettingsState = SyncSettingsState(service: service)
    }
    
}
