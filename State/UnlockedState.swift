import Event
import Foundation
import Model
import Sort

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status: Status
    @Published var searchText: String = ""
    @Published var sheet: Sheet?
    private let inputBuffer = EventBuffer<Input>()
    private let service: AppServiceProtocol
    
    init(collation: AlphabeticCollation<StoreItemDetailState>?, service: AppServiceProtocol) {
        self.status = collation.map(Status.items) ?? .emptyStore
        self.service = service
        
        let inputs = service.events.compactMap(Input.init)
        inputBuffer.enqueue(inputs)
        
        Task {
            for await input in inputBuffer.events {
                switch input {
                case .reload:
                    do {
                        let states = service.loadInfos().map { info in
                            StoreItemDetailState(storeItemInfo: info, service: service)
                        }
                        let collation = try await AlphabeticCollation<StoreItemDetailState>(from: states, grouped: \.name)
                        status = .items(collation)
                    }
                    catch {
                        
                    }
                }
            }
        }
    }
    
    func showCreateItemSheet(itemType: SecureItemType) {
        let state = CreateItemState(itemType: itemType, service: service)
        sheet = .createItem(state)
    }
    
    func lock() {
        Task {
            await service.lock()
            status = .locked
        }
    }
    
    #if os(iOS)
    func showSettings() {
        let state = SettingsState(service: service)
        sheet = .settings(state)
    }
    #endif
    
}

extension UnlockedState {
    
    enum Status {
        
        case emptyStore
        case noSearchResults
        case items(AlphabeticCollation<StoreItemDetailState>)
        case locked
        
    }
    
    enum Input {
        
        case reload
        
        init?(_ event: AppServiceEvent) {
            switch event {
            case .storeDidChange:
                self = .reload
            default:
                return nil
            }
        }
        
    }
    
    
    enum Sheet {
        
        case createItem(CreateItemState)
        #if os(iOS)
        case settings(SettingsState)
        #endif
        
    }
    
}

extension UnlockedState.Sheet: Identifiable {
    
   
    var id: String {
        switch self {
        case .createItem:
            return "CreateItem"
        #if os(iOS)
        case .settings:
            return "Settings"
        #endif
        }
    }
    
}
