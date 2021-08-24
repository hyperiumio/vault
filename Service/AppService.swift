import Configuration
import Crypto
import Event
import Foundation
import Model
import Preferences
import Persistence

actor AppService: AppServiceProtocol {
    
    private let defaults: Defaults
    private let cryptor: Cryptor
    private let store: Store
    private let outputMulticast = EventMulticast<Output>()
    
    init() {
        let userDefaults = UserDefaults.standard // use shared user defaults
        
        self.defaults = Defaults(store: userDefaults)
        self.cryptor = Cryptor(keychainAccessGroup: Configuration.appGroup)
        self.store = Store(containerDirectory: Configuration.storeDirectory)
    }
    
    nonisolated var output: AsyncStream<Output> {
        AsyncStream { _ in
            
        }
    }
    
    var didCompleteSetup: Bool {
        get async throws {
            guard let storeID = await defaults.activeStoreID else {
                return false
            }
            return try await store.storeExists(storeID: storeID)
        }
    }
    
    var availableBiometry: BiometryType? {
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
            throw Error.noActiveStoreID
        }
        let derivedKeyContainer = try await store.loadDerivedKeyContainer(storeID: storeID)
        try await cryptor.unlockWithPassword(password, token: derivedKeyContainer, id: storeID)
        
        outputMulticast.send(.didUnlock)
    }
    
    func unlockWithBiometry() async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.noActiveStoreID
        }
        try await cryptor.unlockWithBiometry(id: storeID)
        
        outputMulticast.send(.didUnlock)
    }
    
    func lock() async {
        await cryptor.lock()
        outputMulticast.send(.didLock)
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
        outputMulticast.send(.defaultsDidChange)
    }
    
    func changeMasterPassword(to masterPassword: String) async throws {
        outputMulticast.send(.storeDidChange)
    }
    
    func isPasswordSecure(_ password: String) async -> Bool {
        await PasswordIsSecure(password)
    }
    
    func completeSetup(isBiometryEnabled: Bool, masterPassword: String) async throws {
        /*
        let storeID = UUID()
        let derivedKeyContainer = try CryptorToken.create()
        
        try await store.createStore(storeID: storeID, derivedKeyContainer: derivedKeyContainer)
        await defaults.set(activeStoreID: storeID)
        try await cryptor.createMasterKey(from: masterPassword, token: derivedKeyContainer, with: storeID, usingBiometryUnlock: isBiometryEnabled)
        
        outputMulticast.send(.setupComplete)
         */
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        throw NSError(domain: "", code: 0, userInfo: nil)
    }
    
    func loadInfos() async throws -> AsyncStream<StoreItemInfo> {
        AsyncStream { continuation in
            continuation.yield(StoreItemInfo(id: UUID(), name: "bar", description: "foo", primaryType: .password, secondaryTypes: [], created: .now, modified: .now))
            continuation.finish()
        }
        /*
        guard let storeID = await defaults.activeStoreID else {
            throw Error.noActiveStoreID
        }
        
        let foo = await store.loadItems(storeID: storeID, read: readInfoData).map { itemData in
            try StoreItemInfo(from: itemData)
        }
        
        
        fatalError()
        func readInfoData(context: ReadingContext) throws -> Data {
            Data()
        }
         */
    }
    
    func load(itemID: UUID) async throws -> StoreItem {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.noActiveStoreID
        }
        
        let encryptedMessages = try await store.loadItem(storeID: storeID, itemID: itemID)
        let messages = try await cryptor.decryptMessages(from: encryptedMessages)
        
        guard let encodedInfo = messages.first else {
            throw Error.invalidMessageContainer
        }
        let encodedItems = messages.dropFirst()
        guard let encodedPrimaryItem = encodedItems.first else {
            throw Error.invalidMessageContainer
        }
        let encodedSecondaryItems = encodedItems.dropFirst()
                    
        let info = try StoreItemInfo(from: encodedInfo)
        guard encodedSecondaryItems.count == info.secondaryTypes.count else {
            throw Error.invalidMessageContainer
        }
                    
        let primaryItem = try SecureItem(from: encodedPrimaryItem, as: info.primaryType)
        let secondaryItems = try zip(encodedSecondaryItems, info.secondaryTypes).map { encodedItem, itemType in
            try SecureItem(from: encodedItem, as: itemType)
        }
                    
        return StoreItem(id: info.id, name: info.name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: info.created, modified: info.modified)
        
    }
    
    func save(_ storeItem: StoreItem) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.noActiveStoreID
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
        
        outputMulticast.send(.storeDidChange)
    }
    
    func delete(itemID: UUID) async throws {
        guard let storeID = await defaults.activeStoreID else {
            throw Error.noActiveStoreID
        }
        
        let operations = [
            StoreOperation.delete(itemID: itemID)
        ]
        try await store.commit(storeID: storeID, operations: operations)
        
        outputMulticast.send(.storeDidChange)
    }
    
}

extension AppService {
    
    enum Output {
        
        case storeDidChange
        case defaultsDidChange
        case didLock
        case didUnlock
        case setupComplete
        
    }
    
    enum Error: Swift.Error {
        
        case noActiveStoreID
        case invalidMessageContainer
        
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
struct AppServiceStub: AppServiceProtocol {
    
    nonisolated var output: AsyncStream<AppService.Output> {
        AsyncStream { _ in
            
        }
    }
    
    var didCompleteSetup: Bool {
        true
    }
    
    var availableBiometry: BiometryType? {
        .touchID
    }
    
    var isBiometricUnlockEnabled: Bool {
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
    
    func loadInfos() async throws -> AsyncStream<StoreItemInfo> {
        AsyncStream { continuation in
            continuation.yield(Self.storeItem.info)
            continuation.finish()
        }
    }
    
    func load(itemID: UUID) async throws -> StoreItem {
        Self.storeItem
    }
    
    func save(_ storeItem: StoreItem) async throws {
        print(#function)
    }
    
    func delete(itemID: UUID) async throws {
        print(#function)
    }
    
}

extension AppServiceStub {
    
    static let shared = AppServiceStub()
    
    static var storeItem: StoreItem {
        let loginItem = LoginItem(username: "foo", password: "bar", url: "baz")
        let passwordItem = PasswordItem(password: "qux")
        let id = UUID()
        let primaryItem = SecureItem.login(loginItem)
        let secondaryItems = [
            SecureItem.password(passwordItem)
        ]
        return StoreItem(id: id, name: "quux", primaryItem: primaryItem, secondaryItems: secondaryItems, created: .now, modified: .now)
    }
    
}

extension AppServiceProtocol where Self == AppServiceStub {
    
    static var stub: Self {
        Self.shared
    }
    
}
#endif
