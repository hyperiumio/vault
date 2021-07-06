import Crypto
import Foundation

@MainActor
protocol LockedDependency {
    
    var keychainAvailability: KeychainAvailability { get async }
    
    func decryptMasterKeyWithPassword(_ password: String) async throws -> MasterKey
    func decryptMasterKeyWithBiometry() async throws -> MasterKey
    
}

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published var keychainAvailablility: KeychainAvailability?
    @Published private(set) var status = Status.locked
    
    private let dependency: LockedDependency
    private let yield: Yield
    
    init(dependency: LockedDependency, yield: @escaping Yield) {
        self.dependency = dependency
        self.yield = yield
    }
    
    var inputDisabled: Bool {
        status != .locked
    }
    
    func fetchKeychainAvailability() async {
        keychainAvailablility = await dependency.keychainAvailability
    }
    
    func loginWithPassword() async {
        status = .unlocking
        
        do {
            let masterKey = try await dependency.decryptMasterKeyWithPassword(password)
            yield(masterKey)
            status = .unlocked
        } catch {
            status = .wrongPassword
        }
    }
    
    func loginWithBiometry() async {
        status = .unlocking
        
        do {
            let masterKey = try await dependency.decryptMasterKeyWithBiometry()
            yield(masterKey)
            status = .unlocked
        } catch {
            status = .wrongPassword
        }
    }
    
}

extension LockedState {
    
    typealias Yield = @MainActor (_ masterKey: MasterKey) -> Void
    typealias BiometryType = Crypto.BiometryType
    
    enum Status {
        
        case locked
        case unlocking
        case unlocked
        case wrongPassword
    }
    
}
