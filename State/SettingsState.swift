import Foundation

@MainActor
class SettingsState: ObservableObject, Identifiable {
    
    let securitySettingsState: SecuritySettingsState
    let storeSettingsState: StoreSettingsState
    let syncSettingsState: SyncSettingsState
    
    init(service: AppServiceProtocol) async throws {
        self.securitySettingsState = try await SecuritySettingsState(service: service)
        self.storeSettingsState = StoreSettingsState(service: service)
        self.syncSettingsState = SyncSettingsState(service: service)
    }
    
}
