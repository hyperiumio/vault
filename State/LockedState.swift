import Foundation

@MainActor
protocol LockedDependency {
    
    var biometryType: BiometryType? { get async }
    
    func unlockWithPassword(_ password: String) async throws
    func unlockWithBiometry() async throws
    
}

@MainActor
class LockedState: ObservableObject {
    
    @Published var password = ""
    @Published var biometryType: BiometryType?
    @Published private(set) var status = Status.locked
    
    private let dependency: LockedDependency
    private let done: () -> Void
    
    init(dependency: LockedDependency, done: @escaping () -> Void) {
        self.dependency = dependency
        self.done = done
    }
    
    var inputDisabled: Bool {
        status != .locked
    }
    
    func fetchKeychainAvailability() async {
        biometryType = await dependency.biometryType
    }
    
    func loginWithPassword() async {
        status = .unlocking
        
        do {
            try await dependency.unlockWithPassword(password)
            status = .unlocked
        } catch {
            status = .wrongPassword
        }
    }
    
    func loginWithBiometry() async {
        status = .unlocking
        
        do {
            try await dependency.unlockWithBiometry()
            status = .unlocked
        } catch {
            status = .wrongPassword
        }
    }
    
}

extension LockedState {
    
    enum Status {
        
        case locked
        case unlocking
        case unlocked
        case wrongPassword
        
    }
    
}
