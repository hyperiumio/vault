import Foundation

@MainActor
class SettingsState: ObservableObject, Identifiable {
    
    let securitySettingsState: SecuritySettingsState
    let masterPasswordSettingsState: MasterPasswordSettingsState
    let storeSettingsState: StoreSettingsState
    
    init(service: AppServiceProtocol) {
        self.securitySettingsState = SecuritySettingsState(service: service)
        self.masterPasswordSettingsState = MasterPasswordSettingsState(service: service)
        self.storeSettingsState = StoreSettingsState(service: service)
    }
    
}
