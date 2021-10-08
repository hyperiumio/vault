import Configuration
import Foundation

@MainActor
class StoreSettingsState: ObservableObject {
    
    @Published private(set) var status = Status.input
    let storeInfoSettingsLoadingState: AsyncState<StoreInfoSettingsState>
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.storeInfoSettingsLoadingState = AsyncState {
            try await StoreInfoSettingsState(service: service)
        }
        self.service = service
    }
    
    func presentAction(_ action: Action) {
        status = .action(action)
    }
    
    func presentConfirmation(_ confirmation: Confimation) {
        status = .confirmation(confirmation)
    }
    
    func presentFailure(_ failure: Failure) {
        status = .failure(failure)
    }
    
    func dismissPresentation() {
        status = .input
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
            do {
                try await service.importStoreItems(from: url)
            } catch {
                status = .failure(.importItems)
            }
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
            do {
                try await service.restoreBackup(from: url)
            } catch {
                status = .failure(.restoreBackup)
            }
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
        case confirmation(Confimation)
        case failure(Failure)
        
    }
    
    enum Action: Equatable {
        
        case exportItems(URL)
        case importItems
        case createBackup(URL)
        case restoreBackup
        
        
    }
    
    enum Confimation {
        
        case deleteAllData
        
    }
    
    enum Failure: Error {
        
        case exportItems
        case importItems
        case createBackup
        case restoreBackup
        case deleteAllData
        
    }
    
}

extension StoreSettingsState.Action: Identifiable {
    
    var id: String {
        switch self {
        case .exportItems:
            return "exportItems"
        case .importItems:
            return "importItems"
        case .createBackup:
            return "createBackup"
        case .restoreBackup:
            return "restoreBackup"
        }
    }
    
}

extension StoreSettingsState.Confimation: Identifiable {
    
    var id: Self { self }
    
}

extension StoreSettingsState.Failure: Identifiable {
    
    var id: Self { self }
    
}

