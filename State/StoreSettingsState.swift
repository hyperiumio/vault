import Common
import Configuration
import Foundation
import UniformTypeIdentifiers

@MainActor
class StoreSettingsState: ObservableObject {
    
    @Published private(set) var status = Status.input
    
    let storeInfoSettingsState: StoreInfoSettingsState
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.storeInfoSettingsState = StoreInfoSettingsState(service: service)
        self.service = service
    }
    
    func selectBackupImport() {
        status = .action(.selectBackupImport)
    }
    
    func createBackup() {
        let url = URL(string: "")!
        let selectBackupExport = Action.selectBackupExport(url)
        status = .action(selectBackupExport)
    }
    
    func confirmDeleteAllData() {
        status = .action(.confirmDeleteAllData)
    }
    
    func dismissActions() {
        status = .input
    }
    
    func exportItems(to url: URL) {
        print(url)
    }
    
    func importItems(from url: URL) {
        print(url)
    }
    
    
    
    func restoreBackup(from url: URL) {
        guard case .input = status else {
            return
        }
        
        status = .processing
        
        Task {
            do {
                let resourceContext = ExternalResourceContext(for: url)
                try await resourceContext.read { url in
            
                }
            } catch let error {
                print(error)
            }
        }

    }
    
    func deleteAllData() {
        guard case .input = status else {
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
    
    enum Status: Equatable {
        
        case input
        case action(Action)
        case processing
        case deleteAllDataDidFail
        
    }
    
    enum Action: Equatable {
        
        case selectFilesImport
        case selectFilesExport
        case selectBackupImport
        case selectBackupExport(URL)
        case confirmDeleteAllData
        
    }
    
    
}
