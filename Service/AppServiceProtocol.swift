import Foundation
import Model

protocol AppServiceProtocol {
    
    var events: AsyncStream<AppServiceEvent> { get }
    
    var availableBiometry: AppServiceBiometry? { get async }
    var isBiometricUnlockEnabled: Bool { get async }
    
    func unlockWithPassword(_ password: String) async throws
    func unlockWithBiometry() async throws
    func lock() async
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String
    func isPasswordSecure(_ password: String) async -> Bool
    
    func save(isBiometricUnlockEnabled: Bool) async
    func changeMasterPassword(to masterPassword: String) async throws
    
    var didCompleteSetup: Bool { get async throws }
    func completeSetup(isBiometryEnabled: Bool, masterPassword: String) async throws
    
    
    func loadInfos() -> AsyncThrowingStream<StoreItemInfo, Error>
    func loadInfoData() -> AsyncThrowingStream<Data, Error>
    func load(itemID: UUID) async throws -> StoreItem
    func save(_ storeItem: StoreItem) async throws
    func delete(itemID: UUID) async throws
    func decryptStoreItemInfos<S>(from sequence: S) -> AsyncThrowingMapSequence<S, StoreItemInfo> where S: AsyncSequence, S.Element == Data
    
}
