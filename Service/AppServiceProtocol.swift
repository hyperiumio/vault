import Configuration
import Crypto
import Foundation
import Model
import Preferences
import Persistence

protocol AppServiceProtocol {
    
    var events: AsyncStream<AppEvent> { get async }
    var didCompleteSetup: Bool { get async throws }
    var availableBiometry: BiometryType? { get async }
    var isBiometricUnlockEnabled: Bool { get async }
    
    func unlockWithPassword(_ password: String) async throws
    func unlockWithBiometry() async throws
    func password(length: Int, digit: Bool, symbol: Bool) async -> String
    func save(isBiometricUnlockEnabled: Bool) async
    func changeMasterPassword(to masterPassword: String) async throws
    func isPasswordSecure(_ password: String) async -> Bool
    func completeSetup(isBiometryEnabled: Bool, masterPassword: String) async throws
    func loadInfos() async throws -> [StoreItemInfo]
    func load(itemID: UUID) async throws -> StoreItem
    func save(_ storeItem: StoreItem) async throws
    func delete(itemID: UUID) async throws
    
}
