import Crypto
import Foundation
import Model
import Preferences
import SwiftUI

@MainActor
class SetupState: ObservableObject {
    
    @Published private(set) var step = Step.choosePassword
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var isBiometricUnlockEnabled = false
    @Published var setupError: Error?
    
    private let service: Service
    private let yield: Yield
    
    init(service: Service, yield: @escaping Yield) {
        self.service = service
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
    
    var nextButtonTitle: LocalizedStringKey {
        switch step {
        case .choosePassword, .repeatPassword, .enableBiometricUnlock:
            return .continue
        case .completeSetup:
            return .setupComplete
        }
    }
    
    func back() {
        switch step {
        case .choosePassword:
            return
        case .repeatPassword:
            step = .choosePassword
        case .enableBiometricUnlock:
            step = .repeatPassword
        case .completeSetup:
            step = .enableBiometricUnlock(biometryType: .faceID)
        }
    }
    
    func next() async {
        switch step {
        case .choosePassword:
            step = .repeatPassword
        case .repeatPassword:
            step = .enableBiometricUnlock(biometryType: .touchID)
        case .enableBiometricUnlock:
            step = .completeSetup
        case .completeSetup:
            do {
                let (derivedKey, masterKey, derivedKeyContainer, masterKeyContainer) = try await service.security.createKeySet(password: password)
                let storeID = try await service.store.createStore(derivedKeyContainer: derivedKeyContainer, masterKeyContainer: masterKeyContainer)
                await service.defaults.set(activeStoreID: storeID)
                await service.defaults.set(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
                if isBiometricUnlockEnabled {
                    try await service.security.storeSecret(derivedKey, forKey: "DerivedKey")
                }
                
                yield(derivedKey, masterKey, storeID)
            } catch {
                setupError = .completeSetupDidFail
            }
        }
    }
    
}

extension SetupState {
    
    typealias Yield = @MainActor (_ derivedKey: DerivedKey, _ masterKey: MasterKey, _ storeID: UUID) -> Void
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
