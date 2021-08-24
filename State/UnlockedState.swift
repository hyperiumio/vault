import Event
import Foundation
import Model
import Sort

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status = Status.emptyStore
    @Published var searchText: String = ""
    @Published var sheet: Sheet?
    
    private let inputBuffer = EventBuffer<Input>()
    
    init(service: AppServiceProtocol) {
        Task {
            for await output in service.output {
                switch output {
                case .storeDidChange:
                    inputBuffer.enqueue(.reload)
                default:
                    continue
                }
            }
        }
        let serviceOutputStream = service.output.compactMap(Input.init)
        inputBuffer.enqueue(serviceOutputStream)
        
        Task {
            for await input in inputBuffer.events {
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
        inputBuffer.enqueue(input)
    }
    
    func lock() {
        inputBuffer.enqueue(.lock)
    }
    
    #if os(iOS)
    func showSettings() {
        inputBuffer.enqueue(.settings)
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
        case reload
        
        #if os(iOS)
        case settings
        #endif
        
        init?(_ output: AppService.Output) {
            switch output {
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
