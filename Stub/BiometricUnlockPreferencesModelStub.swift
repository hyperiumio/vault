#if DEBUG
import Combine

class BiometricUnlockPreferencesModelStub: BiometricUnlockPreferencesModelRepresentable {
    
    @Published var password: String
    @Published var status: BiometricUnlockPreferencesStatus
    @Published var biometricType: BiometricType
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    init(password: String, status: BiometricUnlockPreferencesStatus, biometricType: BiometricType) {
        self.password = password
        self.status = status
        self.biometricType = biometricType
    }
    
    func enabledBiometricUnlock() {}
    
    let doneSubject = PassthroughSubject<Void, Never>()
    
}
#endif
