import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol SetupModelRepresentable: ObservableObject, Identifiable {
    
    typealias Status = SetupStatus
    
    var password: String { get set }
    var repeatedPassword: String { get set }
    var status: Status { get }
    var done: AnyPublisher<Vault, Never> { get }
    
    init(vaultContainerDirectory: URL, preferencesManager: PreferencesManager)
    
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
    @Published private(set) var status = Status.none
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private let vaultContainerDirectory: URL
    private let preferencesManager: PreferencesManager
    private var createVaultSubscription: AnyCancellable?
    
    required init(vaultContainerDirectory: URL, preferencesManager: PreferencesManager) {
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
        createVaultSubscription = Vault.create(in: vaultContainerDirectory, with: password, using: Cryptor.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .vaultCreationFailed
                }
            } receiveValue: { [preferencesManager, doneSubject] vault in
                preferencesManager.set(activeVaultIdentifier: vault.id)
                doneSubject.send(vault)
            }
    }
    
}


