import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol SetupModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var repeatedPassword: String { get set }
    var status: SetupStatus { get }
    var done: AnyPublisher<VaultItemStore, Never> { get }
    
    func createMasterKey()
    
}

enum SetupStatus {
    
    case none
    case loading
    case passwordMismatch
    case insecurePassword
    case vaultCreationFailed
    
}

class SetupModel: SetupModelRepresentable {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published private(set) var status = SetupStatus.none
    
    var done: AnyPublisher<VaultItemStore, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<VaultItemStore, Never>()
    private let vaultContainerDirectory: URL
    private let preferencesManager: PreferencesManager
    private var createVaultSubscription: AnyCancellable?
    
    init(vaultContainerDirectory: URL, preferencesManager: PreferencesManager) {
        self.vaultContainerDirectory = vaultContainerDirectory
        self.preferencesManager = preferencesManager
        
        Publishers.Merge($password, $repeatedPassword)
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func createMasterKey() {
        guard password == repeatedPassword else {
            status = .passwordMismatch
            return
        }
        guard password.count >= 8 else {
            status = .insecurePassword
            return
        }
        
        do {
            try FileManager.default.createDirectory(at: vaultContainerDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            status = .vaultCreationFailed
            return
        }
        
        status = .loading
        createVaultSubscription = VaultItemStore.create(in: vaultContainerDirectory, with: password, using: Cryptor.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .vaultCreationFailed
                }
            } receiveValue: { [preferencesManager, doneSubject] store in
                preferencesManager.set(activeVaultIdentifier: store.id)
                doneSubject.send(store)
            }
    }
    
}


