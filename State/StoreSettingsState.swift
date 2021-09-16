import Configuration
import Foundation
import UniformTypeIdentifiers

@MainActor
class StoreSettingsState: ObservableObject {
    
    @Published private(set) var status = Status.input
    @Published var currentAction: Action?
    
    let storeInfoSettingsState: StoreInfoSettingsState
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.storeInfoSettingsState = StoreInfoSettingsState(service: service)
        self.service = service
    }
    
    var allowedImportTypes: [UTType] {
        switch currentAction {
        case .selectFilesImport?:
            return [Configuration.vaultItems]
        case .selectBackupImport?:
            return [Configuration.vaultBackup]
        case .selectFilesExport?, .selectBackupExport?, .confirmDeleteAllData?, .none:
            return []
        }
    }
    
    func exportItems(to url: URL) {
        print(url)
    }
    
    func importItems(from url: URL) {
        print(url)
    }
    
    func createBackup(at url: URL) {
        print(url)
    }
    
    func restoreBackup(from url: URL) {
        print(url)
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
    
    enum Action {
        
        case selectFilesImport
        case selectFilesExport
        case selectBackupImport
        case selectBackupExport
        case confirmDeleteAllData
        
    }
    
}
