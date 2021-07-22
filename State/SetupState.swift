import Common
import Foundation
import Model

protocol SetupDependency {
    
    var biometryType: BiometryType? { get async }
    
    func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws -> MasterKey
    
}

@MainActor
class SetupState: ObservableObject {
    
    @Published private(set) var step = Step.choosePassword
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var isBiometricUnlockEnabled = false
    @Published var setupError: Error?
    
    private let yield = AsyncValue<MasterKey>()
    private let dependency: SetupDependency
    
    init(dependency: SetupDependency) {
        self.dependency = dependency
    }
    
    var masterKey: MasterKey {
        get async {
            await yield.value
        }
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
        setupError = nil
        
        switch step {
        case .choosePassword:
            return
        case .repeatPassword:
            step = .choosePassword
        case .enableBiometricUnlock:
            step = .repeatPassword
        case .completeSetup:
            if let biometryType = await dependency.biometryType {
                step = .enableBiometricUnlock(biometryType: biometryType)
            } else {
                step = .repeatPassword
            }
        }
    }
    
    func next() async {
        setupError = nil
        
        switch step {
        case .choosePassword:
            guard password.count >= 1 else {
                setupError = .insecurePassword
                return
            }
            step = .repeatPassword
        case .repeatPassword:
            if let biometryType = await dependency.biometryType {
                step = .enableBiometricUnlock(biometryType: biometryType)
            } else {
                step = .completeSetup
            }
        case .enableBiometricUnlock:
            step = .completeSetup
        case .completeSetup:
            do {
                let masterKey = try await dependency.createStore(isBiometryEnabled: isBiometricUnlockEnabled, masterPassword: password)
                await yield.set(masterKey)
            } catch {
                setupError = .completeSetupDidFail
            }
        }
    }
    
}

extension SetupState {
    
    enum Step {
        
        case choosePassword
        case repeatPassword
        case enableBiometricUnlock(biometryType: BiometryType)
        case completeSetup
        
    }
    
    enum Error: Swift.Error {
        
        case insecurePassword
        case completeSetupDidFail
        
    }
    
}
