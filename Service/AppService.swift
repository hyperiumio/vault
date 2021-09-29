import Combine
import Configuration
import Crypto
import Collection
import Foundation
import Model
import Preferences
import Persistence
import Transfer

actor AppService: AppServiceProtocol {
    
    private let defaults: Defaults
    private let cryptor: Cryptor
    private let store: Store
    private let eventPublisher = PassthroughSubject<AppServiceEvent, Never>()
    
    init() {
        let userDefaults = UserDefaults.standard // use shared user defaults
        
        self.defaults = Defaults(store: userDefaults)
        self.cryptor = Cryptor(keychainAccessGroup: Configuration.appGroup)
        self.store = Store(containerDirectory: Configuration.databaseDirectory)
    }
    
    nonisolated var events: AsyncPublisher<PassthroughSubject<AppServiceEvent, Never>> {
        eventPublisher.values
    }
    
    var didCompleteSetup: Bool {
        get async throws {
            guard let storeID = await defaults.activeStoreID else {
                return false
            }
            return try await store.storeExists(storeID: storeID)
        }
    }
    
    var availableBiometry: AppServiceBiometry? {
        get async {
            switch await cryptor.biometryAvailablility {
            case .notAvailable, .notEnrolled:
                return nil
            case .enrolled(.touchID):
                return .touchID
            case .enrolled(.faceID):
                return .faceID
            }
        }
    }
    
    func unlockWithPassword(_ password: String) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        let derivedKeyContainer = try await store.loadDerivedKeyContainer(storeID: storeID)
        try await cryptor.unlockWithPassword(password, token: derivedKeyContainer, id: storeID)
    }
    
    func unlockWithBiometry() async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        try await cryptor.unlockWithBiometry(id: storeID)
    }
    
    func lock() async {
        await cryptor.lock()
    }
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String {
       await Password(length: length, uppercase: true, lowercase: true, digit: digit, symbol: symbol)
    }
    
    var isBiometricUnlockEnabled: Bool {
        get async {
            await defaults.isBiometricUnlockEnabled
        }
    }
    
    func save(isBiometricUnlockEnabled: Bool) async {
        await defaults.set(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
        eventPublisher.send(.defaultsDidChange)
    }
    
    func changeMasterPassword(to masterPassword: String) async throws {
        eventPublisher.send(.storeDidChange)
    }
    
    func isPasswordSecure(_ password: String) async -> Bool {
        await PasswordIsSecure(password)
    }
    
    func completeSetup(isBiometryEnabled: Bool, masterPassword: String) async throws {
        let storeID = UUID()
        let derivedKeyContainer = try CryptorToken.create()
        
        try await cryptor.createMasterKey(from: masterPassword, token: derivedKeyContainer, with: storeID, usingBiometryUnlock: isBiometryEnabled)
        try await store.createStore(storeID: storeID, derivedKeyContainer: derivedKeyContainer)
        await defaults.set(activeStoreID: storeID)
    }
    
    nonisolated func loadInfos() async throws -> AsyncThrowingMapSequence<AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Data>, StoreItemInfo> {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        
        return await store.loadItems(storeID: storeID) { context in
            try context.bytes
        }
        .map { [cryptor] bytes in
            try await cryptor.decryptMessage(at: 0, from: bytes)
        }
        .map { data in
            try StoreItemInfo(from: data)
        }
    }
    
    nonisolated func loadInfoData() -> AsyncThrowingStream<Data, Error> {
        AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }
    
    func loadStoreInfo() async throws -> AppServiceStoreInfo {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        
        let created = try await store.loadStoreInfo(storeID: storeID).created
        
        var bankAccountItemCount = 0
        var bankCardItemCount = 0
        var customItemCount = 0
        var fileItemCount = 0
        var loginItemCount = 0
        var noteItemCount = 0
        var passwordItemCount = 0
        var wifiItemCount = 0
        for try await infoItem in try await loadInfos() {
            switch infoItem.primaryType {
            case .login:
                loginItemCount += 1
            case .password:
                passwordItemCount += 1
            case .wifi:
                wifiItemCount += 1
            case .note:
                noteItemCount += 1
            case .bankCard:
                bankCardItemCount += 1
            case .bankAccount:
                bankAccountItemCount += 1
            case .custom:
                customItemCount += 1
            case .file:
                fileItemCount += 1
            }
        }
        
        return AppServiceStoreInfo(created: created, bankAccountItemCount: bankAccountItemCount, bankCardItemCount: bankCardItemCount, customItemCount: customItemCount, fileItemCount: fileItemCount, loginItemCount: loginItemCount, noteItemCount: noteItemCount, passwordItemCount: passwordItemCount, wifiItemCount: wifiItemCount)
    }
    
    func load(itemID: UUID) async throws -> StoreItem {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        
        let encryptedMessages = try await store.loadItem(storeID: storeID, itemID: itemID)
        let messages = try await cryptor.decryptMessages(from: encryptedMessages)
        
        guard let encodedInfo = messages.first else {
            throw AppServiceError.invalidMessageContainer
        }
        let encodedItems = messages.dropFirst()
        guard let encodedPrimaryItem = encodedItems.first else {
            throw AppServiceError.invalidMessageContainer
        }
        let encodedSecondaryItems = encodedItems.dropFirst()
                    
        let info = try StoreItemInfo(from: encodedInfo)
        guard encodedSecondaryItems.count == info.secondaryTypes.count else {
            throw AppServiceError.invalidMessageContainer
        }
                    
        let primaryItem = try SecureItem(from: encodedPrimaryItem, as: info.primaryType)
        let secondaryItems = try zip(encodedSecondaryItems, info.secondaryTypes).map { encodedItem, itemType in
            try SecureItem(from: encodedItem, as: itemType)
        }
                    
        return StoreItem(id: info.id, name: info.name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: info.created, modified: info.modified)
        
    }
    
    func save(_ storeItem: StoreItem) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        
        let encodedInfo = try storeItem.info.encoded
        let items = [storeItem.primaryItem] + storeItem.secondaryItems
        let encodedItems = try items.map { item in
            try item.value.encoded
        }
        let messages = [encodedInfo] + encodedItems
        let encryptedMessages = try await cryptor.encryptMessages(messages)
        
        let operations = [
            StoreOperation.save(itemID: storeItem.id, item: encryptedMessages)
        ]
        try await store.commit(storeID: storeID, operations: operations)
        
        eventPublisher.send(.storeDidChange)
    }
    
    func delete(itemID: UUID) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        
        let operations = [
            StoreOperation.delete(itemID: itemID)
        ]
        try await store.commit(storeID: storeID, operations: operations)
        
        eventPublisher.send(.storeDidChange)
    }
    
    nonisolated func decryptStoreItemInfos<S>(from sequence: S) -> AsyncThrowingMapSequence<S, StoreItemInfo> where S: AsyncSequence, S.Element == Data {
        sequence.map { [cryptor] data in
            let decryptedData = try await cryptor.decryptMessage(at: 0, from: data)
            return try StoreItemInfo(from: decryptedData)
        }
    }
    
    func deleteAllData() async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        
        try await store.deleteAllItems(storeID: storeID)
    }
    
    func exportStoreItems() async throws -> URL {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(Configuration.vaultItemsDirectoryName)
        try await ItemsExport(at: url) { resourceLocator in
            //let encryptedItems = await store.loadItems(storeID: storeID)
            //let decryptedItems = await cryptor.decryptStoreItems(encryptedItems)
        }
        
        return url
    }
    
    func importStoreItems(from url: URL) async throws {
        throw AppServiceError.noActiveStoreID
    }
    
    func createBackup() async throws -> URL {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        guard let wrappedMasterKey = try await cryptor.wrappedMasterKey else {
            throw AppServiceError.createBackupFailed
        }
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(Configuration.backupDirectoryName)
        try await BackupCreate(at: url) { [store] resourceLocator in
            try wrappedMasterKey.write(to: resourceLocator.masterKeyURL, options: .atomic)
            try await store.dump(storeID: storeID, to: resourceLocator.storeURL)
        }
        
        return url
    }
    
    func restoreBackup(from url: URL) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw AppServiceError.noActiveStoreID
        }
        
        try await BackupRestore(from: url) { resourceLocator in
            
        }
        
        try await store.delete(storeID: storeID)
    }
    
    var recoveryKey: Data {
        get async throws {
            guard let storeID = await defaults.activeStoreID else {
                throw AppServiceError.noActiveStoreID
            }
            
            return Data()
        }
    }
    
    var recoveryKeyPDF: Data {
        get async throws {
            guard let storeID = await defaults.activeStoreID else {
                throw AppServiceError.noActiveStoreID
            }
            
            return Data()
        }
    }
    
}

extension AppService {
    
    static let shared = AppService()
    
}

extension AppServiceProtocol where Self == AppService {
    
    static var production: Self {
        Self.shared
    }
    
}

extension UserDefaults: PersistenceProvider {}

#if DEBUG
actor AppServiceStub: AppServiceProtocol {
    
    func deleteAllData() async throws {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    func loadStoreInfo() async throws -> AppServiceStoreInfo {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        
        return AppServiceStoreInfo(created: .now, bankAccountItemCount: 0, bankCardItemCount: 1, customItemCount: 2, fileItemCount: 3, loginItemCount: 4, noteItemCount: 5, passwordItemCount: 6, wifiItemCount: 7)
    }
    
    
    nonisolated var events: AsyncPublisher<PassthroughSubject<AppServiceEvent, Never>> {
        PassthroughSubject<AppServiceEvent, Never>().values
    }
    
    nonisolated var didCompleteSetup: Bool {
        true
    }
    
    nonisolated var availableBiometry: AppServiceBiometry? {
        .touchID
    }
    
    nonisolated var isBiometricUnlockEnabled: Bool {
        true
    }
    
    func unlockWithPassword(_ password: String) async throws {
        print(#function)
    }
    
    func unlockWithBiometry() async throws {
        print(#function)
    }
    
    func lock() async {
        print(#function)
    }
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String {
        "foo"
    }
    
    func save(isBiometricUnlockEnabled: Bool) async {
        print(#function)
    }
    
    func changeMasterPassword(to masterPassword: String) async throws {
        print(#function)
    }
    
    func isPasswordSecure(_ password: String) async -> Bool {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        
        return true
    }
    
    func completeSetup(isBiometryEnabled: Bool, masterPassword: String) async throws {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    nonisolated func loadInfos() async throws -> AsyncThrowingMapSequence<AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Data>, StoreItemInfo> {
        throw NSError()
    }
    
    nonisolated func loadInfoData() -> AsyncThrowingStream<Data, Error> {
        AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }
    
    func load(itemID: UUID) async throws -> StoreItem {
        Self.storeItem
    }
    
    func save(_ storeItem: StoreItem) async throws {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    func delete(itemID: UUID) async throws {
        print(#function)
    }
    
    nonisolated func decryptStoreItemInfos<S>(from sequence: S) -> AsyncThrowingMapSequence<S, StoreItemInfo> where S: AsyncSequence, S.Element == Data {
        fatalError()
    }
    
    func exportStoreItems() async throws -> URL {
        URL(fileURLWithPath: "")
    }
    
    func importStoreItems(from url: URL) async throws {
        print(#function)
    }
    
    func createBackup() async throws -> URL {
        URL(fileURLWithPath: "")
    }
    
    func restoreBackup(from url: URL) async throws {
        print(#function)
    }
    
    var recoveryKey: Data {
        get async throws {
            Data()
        }
    }
    
    var recoveryKeyPDF: Data {
        get async throws {
            Data()
        }
    }
    
}

extension AppServiceStub {
    
    static let shared = AppServiceStub()
    
    static let storeItem: StoreItem = {
        let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
        let passwordItem = PasswordItem(password: "qux")
        let id = UUID()
        let primaryItem = SecureItem.login(loginItem)
        let secondaryItems = [
            SecureItem.password(passwordItem)
        ]
        return StoreItem(id: id, name: "quux", primaryItem: primaryItem, secondaryItems: secondaryItems, created: .now, modified: .now)
    }()
    
}

extension AppServiceProtocol where Self == AppServiceStub {
    
    static var stub: Self {
        Self.shared
    }
    
}
#endif
