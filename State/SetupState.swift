import Crypto
import Foundation
import Model

@MainActor
protocol SetupDependency {
    
    var biometryTypeAvailability: BiometryType? { get async }
    
    func createStore(isBiometryEnabled: Bool) async throws -> (masterKey: MasterKey, storeID: UUID)
    
}

@MainActor
class SetupState: ObservableObject {
    
    @Published private(set) var step = Step.choosePassword
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var isBiometricUnlockEnabled = false
    @Published var setupError: Error?
    
    private let dependency: SetupDependency
    private let yield: Yield
    
    init(dependency: SetupDependency, yield: @escaping Yield) {
        self.dependency = dependency
        self.yield = yield
    }
    
    var isBackButtonVisible: Bool {
        switch step {
        case .choosePassword:
            return false
        case .repeatPassword, .enableBiometricUnlock, .completeSetup:
            return true
        }
    }
    
    func back() async {
        switch step {
        case .choosePassword:
            return
        case .repeatPassword:
            step = .choosePassword
        case .enableBiometricUnlock:
            step = .repeatPassword
        case .completeSetup:
            if let biometryType = await dependency.biometryTypeAvailability {
                step = .enableBiometricUnlock(biometryType: biometryType)
            } else {
                step = .repeatPassword
            }
            
        }
    }
    
    func next() async {
        switch step {
        case .choosePassword:
            step = .repeatPassword
        case .repeatPassword:
            if let biometryType = await dependency.biometryTypeAvailability {
                step = .enableBiometricUnlock(biometryType: biometryType)
            } else {
                step = .completeSetup
            }
        case .enableBiometricUnlock:
            step = .completeSetup
        case .completeSetup:
            do {
                let response = try await dependency.createStore(isBiometryEnabled: isBiometricUnlockEnabled)
                yield(response.masterKey, response.storeID)
            } catch {
                setupError = .completeSetupDidFail
            }
        }
    }
    
}

extension SetupState {
    
    typealias Yield = @MainActor (_ masterKey: MasterKey, _ storeID: UUID) -> Void
    typealias BiometryType = Crypto.BiometryType
    
    enum Step {
        
        case choosePassword
        case repeatPassword
        case enableBiometricUnlock(biometryType: BiometryType)
        case completeSetup
        
    }
    
    enum Error: Swift.Error {
        
        case completeSetupDidFail
        
    }
    
}
