import Collection
import Foundation
import Model
import Sort

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status = Status.emptyStore
    @Published var searchText: String = ""
    @Published var sheet: Sheet?
    
    private let inputs = Queue<Input>()
    
    init(service: AppServiceProtocol) {
        Task {
            for await output in service.output {
                switch output {
                case .storeDidChange:
                    await inputs.enqueue(.reload)
                default:
                    continue
                }
            }
        }
        
        Task {
            for await input in AsyncStream(unfolding: inputs.dequeue) {
                switch input {
                case let .createItem(itemType):
                    let state = CreateItemState(itemType: itemType, service: service)
                    sheet = .createItem(state)
                case .lock:
                    await service.lock()
                case .reload:
                    do {
                        let states = try await service.loadInfos().map { info in
                            StoreItemDetailState(storeItemInfo: info, service: service)
                        }
                        let collation = try await Collation(from: states) { state in
                            state.name
                        }
                        status = .items(collation)
                    }
                    catch {
                        
                    }
                #if os(iOS)
                case .settings:
                    let state = SettingsState(service: service)
                    sheet = .settings(state)
                #endif
                }
            }
        }
    }
    
    func showCreateItemSheet(itemType: SecureItemType) {
        let input = Input.createItem(itemType: itemType)
        Task {
            await inputs.enqueue(input)
        }
    }
    
    func lock() {
        Task {
            await inputs.enqueue(.lock)
        }
    }
    
    #if os(iOS)
    func showSettings() {
        Task {
            await inputs.enqueue(.settings)
        }
    }
    #endif
    
}

extension UnlockedState {
    
    typealias Collation = AlphabeticCollation<StoreItemDetailState>
    
    enum Status {
        
        case emptyStore
        case noSearchResults
        case items(Collation)
        
    }
    
    enum Input {
        
        case createItem(itemType: SecureItemType)
        case lock
        case settings
        case reload
        
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
