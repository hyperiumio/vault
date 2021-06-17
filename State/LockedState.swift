import Combine
import Crypto
import Foundation
import Preferences
import Model
import Sort

@MainActor
protocol LockedStateRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var keychainAvailability: Keychain.Availability { get }
    var status: LockedStatus { get }
    
    func loginWithMasterPassword() async
    func loginWithBiometrics() async
    
}

@MainActor
class LockedState: LockedStateRepresentable {
    
    @Published var password = ""
    @Published private(set) var keychainAvailability: Keychain.Availability
    @Published private(set) var status = LockedStatus.locked(cancelled: false)
    
    private let keychain: Keychain
    
    init(store: Store, preferences: Preferences, keychain: Keychain) {
        fatalError()
    }
    
    func loginWithMasterPassword() async {
    }
    
    func loginWithBiometrics() async {
    }
    
}

enum LockedStatus: Equatable {
    
    case locked(cancelled: Bool)
    case unlocking
    case unlocked
    
}

enum LockedError: Error, Identifiable {
    
    case wrongPassword
    case unlockFailed
    
    var id: Self { self }
    
}


#if DEBUG
class LockedStateStub: LockedStateRepresentable {
    
    @Published var password = ""
    @Published var keychainAvailability = Keychain.Availability.enrolled(.faceID)
    @Published private(set) var status = LockedStatus.locked(cancelled: false)
    
    let vaultDirectory = URL(fileURLWithPath: "")
    
    func loginWithMasterPassword() async {}
    func loginWithBiometrics() async {}
    
}
#endif
