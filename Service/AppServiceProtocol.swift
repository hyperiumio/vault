import Combine
import Foundation
import Model

protocol AppServiceProtocol {
    
    var output: AsyncPublisher<PassthroughSubject<AppService.Output, Never>> { get }
    var didCompleteSetup: Bool { get async throws }
    var availableBiometry: BiometryType? { get async }
    var isBiometricUnlockEnabled: Bool { get async }
    
    func unlockWithPassword(_ password: String) async throws
    func unlockWithBiometry() async throws
    func lock() async
    func password(length: Int, digit: Bool, symbol: Bool) async -> String
    func save(isBiometricUnlockEnabled: Bool) async
    func changeMasterPassword(to masterPassword: String) async throws
    func isPasswordSecure(_ password: String) async -> Bool
    func completeSetup(isBiometryEnabled: Bool, masterPassword: String) async throws
    func loadInfos() async throws -> AsyncStream<StoreItemInfo>
    func load(itemID: UUID) async throws -> StoreItem
    func save(_ storeItem: StoreItem) async throws
    func delete(itemID: UUID) async throws
    
}
