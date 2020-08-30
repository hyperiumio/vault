#if DEBUG
import Combine

class VaultItemCreationModelStub: VaultItemCreationModelRepresentable {
    
    typealias VaultItemModel = VaultItemModelStub
    
    let detailModels: [VaultItemModelStub]
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    init(detailModels: [VaultItemModelStub]) {
        self.detailModels = detailModels
    }
    
    let doneSubject = PassthroughSubject<Void, Never>()
    
}
#endif
