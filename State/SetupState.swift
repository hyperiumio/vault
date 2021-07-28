import Common
import Foundation
import Model

@MainActor
class SetupState: ObservableObject {
    
    @Published private(set) var step = Step.choosePassword
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var isBiometricUnlockEnabled = false
    @Published var setupError: Error?
    
    private let yield = AsyncValue<Void>()
    private let setupService: SetupServiceProtocol
    
    init(dependency: Dependency) {
        self.setupService = dependency.setupService
    }
    
    var done: Void {
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
            if let biometryType = await setupService.availableBiometry {
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
            if let biometryType = await setupService.availableBiometry {
                step = .enableBiometricUnlock(biometryType: biometryType)
            } else {
                step = .completeSetup
            }
        case .enableBiometricUnlock:
            step = .completeSetup
        case .completeSetup:
            do {
                try await setupService.createStore(isBiometryEnabled: isBiometricUnlockEnabled, masterPassword: password)
                await yield.set(())
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
