import Foundation
import Model

@MainActor
class SetupState: ObservableObject {
    
    @Published private(set) var step = Step.choosePassword
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var isBiometricUnlockEnabled = false
    @Published var setupError: SetupError?
    
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    private(set) var direction = Direction.forward
    
    var isBackButtonVisible: Bool {
        switch step {
        case .choosePassword:
            return false
        case .repeatPassword, .enableBiometricUnlock, .completeSetup:
            return true
        }
    }
    
    var isNextButtonEnabled: Bool {
        switch step {
        case .choosePassword:
            return !password.isEmpty
        case .repeatPassword:
            return !repeatedPassword.isEmpty
        case .enableBiometricUnlock, .completeSetup:
            return true
        }
    }
    
    func back() async {
        direction = .backward
        setupError = nil
        
        switch step {
        case .choosePassword:
            return
        case .repeatPassword:
            step = .choosePassword
        case .enableBiometricUnlock:
            step = .repeatPassword
        case .completeSetup:
            if let biometryType = await service.availableBiometry {
                step = .enableBiometricUnlock(biometryType: biometryType)
            } else {
                step = .repeatPassword
            }
        }
    }
    
    func next() async {
        direction = .forward
        setupError = nil
        
        switch step {
        case .choosePassword:
            if await service.isPasswordSecure(password) {
                step = .repeatPassword
            } else {
                setupError = .insecurePassword
            }
        case .repeatPassword:
            if let biometryType = await service.availableBiometry {
                step = .enableBiometricUnlock(biometryType: biometryType)
            } else {
                step = .completeSetup
            }
        case .enableBiometricUnlock:
            step = .completeSetup
        case .completeSetup:
            do {
                try await service.completeSetup(isBiometryEnabled: isBiometricUnlockEnabled, masterPassword: password)
            } catch {
                setupError = .completeSetupDidFail
            }
        }
    }
    
}

extension SetupState {
    
    enum Step: Equatable {
        
        case choosePassword
        case repeatPassword
        case enableBiometricUnlock(biometryType: BiometryType)
        case completeSetup
        
    }
    
    enum Direction {
        
        case forward
        case backward
        
    }
    
    enum SetupError: Error {
        
        case insecurePassword
        case completeSetupDidFail
        
    }
    
}
