import Configuration
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
    
    func present(_ action: Action?) {
        status = action.map(Status.action) ?? .input
    }
    
    func exportItems() {
        guard status == .input else {
            return
        }
        
        status = .processing
        Task {
            do {
                let url = try await service.exportStoreItems()
                let exportItems = Action.exportItems(url)
                status = .action(exportItems)
            } catch {
                status = .failure(.exportItems)
            }
        }
    }
    
    func importItems(from url: URL) {
        guard status == .input else {
            return
        }
        
        status = .processing
        Task {
            status = .input
        }
    }
    
    func createBackup() {
        guard status == .input else {
            return
        }
        
        status = .processing
        Task {
            do {
                let url = try await service.createBackup()
                let createBackup = Action.createBackup(url)
                status = .action(createBackup)
            } catch {
                status = .failure(.createBackup)
            }
        }
    }
    
    func restoreBackup(from url: URL) {
        guard status == .input else {
            return
        }
        
        status = .processing
        Task {
            status = .input
        }
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
                status = .failure(.deleteAllData)
            }
        }
    }
    
}

extension StoreSettingsState {
    
    enum Status: Equatable {
        
        case input
        case processing
        case action(Action)
        case failure(Failure)
        
    }
    
    enum Action: Equatable {
        
        case importItems
        case exportItems(URL)
        case restoreBackup
        case createBackup(URL)
        case confirmDeleteAllData
        
    }
    
    enum Failure: Error {
        
        case exportItems
        case createBackup
        case deleteAllData
        
    }
    
}
