import Common
import Foundation

protocol LockedDependency {
    
    var biometryType: BiometryType? { get async }
    
    func decryptMasterKeyWithPassword(_ password: String) async throws -> MasterKey?
    func decryptMasterKeyWithBiometry() async throws -> MasterKey?
    
}

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published var biometryType: BiometryType?
    @Published private(set) var status = Status.locked
    
    private let yield = AsyncValue<MasterKey>()
    private let dependency: LockedDependency
    
    init(dependency: LockedDependency) {
        self.dependency = dependency
    }
    
    var masterKey: MasterKey {
        get async {
            await yield.value
        }
    }
    
    var inputDisabled: Bool {
        status != .locked
    }
    
    func fetchKeychainAvailability() async {
        biometryType = await dependency.biometryType
    }
    
    func unlock(with login: Login) async {
        status = .unlocking
        
        do {
            if let masterKey = try await decryptMasterKey(with: login) {
                await yield.set(masterKey)
            } else {
                status = .missingMasterKey
            }
        } catch {
            status = .wrongPassword
        }
        
        func decryptMasterKey(with login: Login) async throws -> MasterKey? {
            switch login {
            case .password:
                return try await dependency.decryptMasterKeyWithPassword(password)
            case .biometry:
                return try await dependency.decryptMasterKeyWithBiometry()
            }
        }
    }
    
}

extension LockedState {
    
    enum Login {
        
        case password
        case biometry
        
    }
    
    enum Status {
        
        case locked
        case unlocking
        case wrongPassword
        case missingMasterKey
        
    }
    
}
