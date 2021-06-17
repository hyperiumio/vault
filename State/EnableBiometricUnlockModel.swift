import Combine
import Crypto
import Preferences

@MainActor
protocol EnableBiometricUnlockModelRepresentable: ObservableObject, Identifiable {
    
    var isEnabled: Bool { get set }
    var biometryType: Keychain.BiometryType { get }
    
    func done() async
    func dismiss() async
    
}

@MainActor
class EnableBiometricUnlockModel: EnableBiometricUnlockModelRepresentable {
    
    @Published var isEnabled = false
    let biometryType: Keychain.BiometryType
    
    private let password: String
    private var keychainStoreSubsciption: AnyCancellable?
    
    init(password: String, biometryType: Keychain.BiometryType) {
        self.password = password
        self.biometryType = biometryType
    }
    
    func done() async {
    }
    
    func dismiss() async {
    }
    
}

enum EnableBiometricUnlockModelEvent {
    
    case done
    case back
    
}

enum EnableBiometricUnlockError: Error, Identifiable {
    
    case didFailEnabling
    case didFailDisabling
    
    var id: Self { self }
    
}

#if DEBUG
class EnableBiometricUnlockModelStub: EnableBiometricUnlockModelRepresentable {
    
    var isEnabled = false
    let biometryType: Keychain.BiometryType
    
    init(biometryType: Keychain.BiometryType) {
        self.biometryType = biometryType
    }
    
    func done() async {}
    func dismiss() async {}
}
#endif
