import Combine
import Crypto
import Preferences

#warning("Todo")
@MainActor
protocol EnableBiometricUnlockStateRepresentable: ObservableObject, Identifiable {
    
    var isEnabled: Bool { get set }
    var biometryType: Keychain.BiometryType { get }
    
    func done() async
    func dismiss() async
    
}

@MainActor
class EnableBiometricUnlockState: EnableBiometricUnlockStateRepresentable {
    
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

enum EnableBiometricUnlockStateEvent {
    
    case done
    case back
    
}

enum EnableBiometricUnlockError: Error, Identifiable {
    
    case didFailEnabling
    case didFailDisabling
    
    var id: Self { self }
    
}

#if DEBUG
class EnableBiometricUnlockStateStub: EnableBiometricUnlockStateRepresentable {
    
    var isEnabled = false
    let biometryType: Keychain.BiometryType
    
    init(biometryType: Keychain.BiometryType) {
        self.biometryType = biometryType
    }
    
    func done() async {}
    func dismiss() async {}
}
#endif
