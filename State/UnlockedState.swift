import Event
import Foundation
import Model
import Search
import Sort

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status: Status
    @Published var searchText: String = "" {
        didSet {
            reload()
        }
    }
    @Published var sheet: Sheet?
    private let inputBuffer = EventBuffer<Input>()
    private let service: AppServiceProtocol
    private var reloadTask: Task<Void, Never>?
    
    init(collation: AlphabeticCollation<StoreItemDetailState>?, service: AppServiceProtocol) {
        self.status = collation.map(Status.items) ?? .emptyStore
        self.service = service
        
        let inputs = service.events.compactMap(Input.init)
        inputBuffer.enqueue(inputs)
        
        Task {
            for await input in inputBuffer.events {
                switch input {
                case .reload:
                    reload()
                }
            }
        }
    }
    
    func showCreateItemSheet(itemType: SecureItemType) {
        let state = CreateItemState(itemType: itemType, service: service)
        sheet = .createItem(state)
    }
    
    #if os(iOS)
    func showSettings() {
        let state = SettingsState(service: service)
        sheet = .settings(state)
    }
    #endif
    
    func lock() {
        Task {
            await service.lock()
            status = .locked
        }
    }
    
    func reload() {
        reloadTask?.cancel()
        reloadTask = Task { [searchText] in
            do {
                let states = try await service.loadInfos()
                    .filter { item in
                        Match(searchText, in: item.name)
                    }
                    .map { [service] info in
                        StoreItemDetailState(storeItemInfo: info, service: service)
                    }
                let collation = try await AlphabeticCollation<StoreItemDetailState>(from: states, grouped: \.name)
                
                guard !Task.isCancelled else {
                    return
                }
                
                status = .items(collation)
            }
            catch {
                status = .loadingItemsFailed
            }
        }
    }
    
}

extension UnlockedState {
    
    enum Status {
        
        case emptyStore
        case noSearchResults
        case items(AlphabeticCollation<StoreItemDetailState>)
        case locked
        case loadingItemsFailed
        
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
    
    #if os(iOS)
    var id: String {
        switch self {
        case .createItem:
            return "CreateItem"
        case .settings:
            return "Settings"
        }
    }
    #endif
    
    #if os(macOS)
    var id: String {
        switch self {
        case .createItem:
            return "CreateItem"
        case .settings:
            return "Settings"
        }
    }
    #endif
    
}
