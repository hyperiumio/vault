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
    private var completeContinuation: CheckedContinuation<Void, Never>?
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    var completed: Void {
        get async {
            await withCheckedContinuation { continuation in
                completeContinuation = continuation
            }
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
            if let biometryType = await service.availableBiometry {
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
                completeContinuation?.resume()
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
    
    enum SetupError: Error {
        
        case insecurePassword
        case completeSetupDidFail
        
    }
    
}
