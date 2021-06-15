import Combine
import Foundation
import Preferences
import Persistence
import Crypto

@MainActor
protocol QuickAccessLockedModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var keychainAvailability: Keychain.Availability { get }
    var status: QuickAccessLockedStatus { get }
    
    func loginWithMasterPassword() async
    func loginWithBiometrics() async
    
}

@MainActor
class QuickAccessLockedModel: QuickAccessLockedModelRepresentable {
    
    @Published var password = ""
    @Published private(set) var status = QuickAccessLockedStatus.locked
    
    let keychainAvailability: Keychain.Availability
    
    private let keychain: Keychain
    
    init(store: Store, preferences: Preferences, keychain: Keychain) {
        fatalError()
    }
    
    func loginWithMasterPassword() async {
    }
    
    func loginWithBiometrics() async {
    }
    
}

enum QuickAccessLockedStatus: Equatable {
    
    case locked
    case unlocking
    case unlocked
    
}

enum QuickAccessLockedError: Error, Identifiable {
    
    case wrongPassword
    case unlockFailed
    
    var id: Self { self }
    
}
