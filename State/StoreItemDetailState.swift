import Collection
import Foundation
import Model

@MainActor
class StoreItemDetailState: ObservableObject, Identifiable {
    
    @Published private(set) var status = Status.initialized
    private let storeItemInfo: StoreItemInfo
    private let inputBuffer = AsyncQueue<Input>()
    
    init(storeItemInfo: StoreItemInfo, service: AppServiceProtocol) {
        self.storeItemInfo = storeItemInfo
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
                switch (input, status) {
                case (.load, .initialized):
                    do {
                        status = .loading
                        let storeItem = try await service.load(itemID: storeItemInfo.id)
                        status = .display(storeItem)
                    } catch {
                        status = .loadingFailed
                    }
                case let (.edit, .display(storeItem)):
                    let editState = StoreItemEditState(editing: storeItem, service: service)
                    status = .edit(editState)
                case let (.cancel, .edit(storeItemEditState)):
                    status = .display(storeItemEditState.editedStoreItem)
                default:
                    continue
                }
            }
        }
    }
    
    var name: String {
        storeItemInfo.name
    }
    
    var description: String? {
        storeItemInfo.description
    }
    
    var primaryType: SecureItemType {
        storeItemInfo.primaryType
    }
    
    func load() {
        Task {
            await inputBuffer.enqueue(.load)
        }
    }
    
    func edit() {
        Task {
            await inputBuffer.enqueue(.edit)
        }
    }
    
    func cancelEdit() {
        Task {
            await inputBuffer.enqueue(.cancel)
        }
    }
    
}

extension StoreItemDetailState {
    
    enum Status {
        
        case initialized
        case loading
        case loadingFailed
        case display(StoreItem)
        case edit(StoreItemEditState)
        
    }
    
    enum Input {
        
        case load
        case edit
        case cancel
        
    }
    
}

