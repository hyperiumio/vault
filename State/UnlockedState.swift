import Foundation
import Model
import Shim
import Sort

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status = Status.emptyStore
    @Published var searchText: String = ""
    @Published var sheet: Sheet?
    
    private let service: AppServiceProtocol
    private var lockContinuation: CheckedContinuation<Void, Never>?
    
    init(service: AppServiceProtocol) {
        self.service = service
        
        Task {
            for await event in await service.events {
                do {
                    switch event {
                    case .storeDidChange:
                        let states = try await service.loadInfos().map { info in
                            StoreItemDetailState(storeItemInfo: info, service: service)
                        }
                        let collation = Collation(from: states) { state in
                            state.name
                        }
                        status = .items(collation)
                    default:
                        continue
                    }
                }
                catch {
                    
                }
            }
        }
    }
    
    var locked: Void {
        get async {
            await withCheckedContinuation { continuation in
                lockContinuation = continuation
            }
        }
    }
    
    func showCreateItemSheet(itemType: SecureItemType) {
        let state = CreateItemState(itemType: itemType, service: service)
        sheet = .createItem(state)
    }
    
    func lock() {
        lockContinuation?.resume()
    }
    
    #if os(iOS)
    func showSettings() {
        let state = SettingsState(service: service)
        sheet = .settings(state)
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
    
    #if os(iOS)
    enum Sheet {
        
        case settings(SettingsState)
        case createItem(CreateItemState)
        
    }
    #endif
    
    #if os(macOS)
    enum Sheet {
        
        case createItem(CreateItemState)
        
    }
    #endif
    
}

extension UnlockedState.Sheet: Identifiable {
    
    #if os(iOS)
    var id: String {
        switch self {
        case .settings:
            return "Settings"
        case .createItem:
            return "CreateItem"
        }
    }
    #endif
    
    #if os(macOS)
    var id: String {
        switch self {
        case .createItem:
            return "CreateItem"
        }
    }
    #endif
    
}
