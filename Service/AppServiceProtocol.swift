import Combine
import Foundation
import Model
import Persistence

protocol AppServiceProtocol {
    
    nonisolated var events: AsyncPublisher<PassthroughSubject<AppServiceEvent, Never>> { get }
    
    var availableBiometry: AppServiceBiometry? { get async throws }
    var touchIDUnlockEnabled: Bool { get async }
    
    func unlockWithPassword(_ password: String) async throws
    func unlockWithBiometry() async throws
    func lock() async
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String
    func isPasswordSecure(_ password: String) async -> Bool
    
    func save(touchIDUnlock: Bool) async
    func save(faceIDUnlock: Bool) async
    func save(watchUnlock: Bool) async
    func save(hidePasswords: Bool) async
    func save(clearPasteboard: Bool) async
    func changeMasterPassword(to masterPassword: String) async throws
    
    var didCompleteSetup: Bool { get async throws }
    func completeSetup(isBiometryEnabled: Bool, masterPassword: String) async throws
    
    
    func loadInfos() async throws -> AsyncThrowingMapSequence<AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Data>, StoreItemInfo>
    func loadInfoData() -> AsyncThrowingStream<Data, Error>
    func load(itemID: UUID) async throws -> StoreItem
    func save(_ storeItem: StoreItem) async throws
    func delete(itemID: UUID) async throws
    func decryptStoreItemInfos<S>(from sequence: S) -> AsyncThrowingMapSequence<S, StoreItemInfo> where S: AsyncSequence, S.Element == Data
    func loadStoreInfo() async throws -> AppServiceStoreInfo
    func deleteAllData() async throws
    
    func exportStoreItems() async throws -> URL
    func importStoreItems(from url: URL) async throws
    func createBackup() async throws -> URL
    func restoreBackup(from url: URL) async throws
    
    var recoveryKeyORCode: Data { get async throws }
    var recoveryKeyPDF: Data { get async throws }
    
}
