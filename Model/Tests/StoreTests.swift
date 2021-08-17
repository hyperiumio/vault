import XCTest
@testable import Model

class StoreTests: XCTestCase {
    
    func testInitResourceLocator() {
        let storeURL = URL(string: "file://foo")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let store = Store(resourceLocator: resourceLocator)
        
        XCTAssertEqual(store.resourceLocator.storeURL, resourceLocator.storeURL)
    }
    
    func testInfo() async throws {
        let storeURL = URL(string: "file://foo")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let configuration = Store.Configuration(load: load)
        let store = Store(resourceLocator: resourceLocator, configuration: configuration)
        
        let info = try await store.info
        
        XCTAssertEqual(info.keyVersion, 1)
        XCTAssertEqual(info.itemVersion, 1)
        XCTAssertEqual(info.id.uuidString, "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A")
        XCTAssertEqual(info.created, ISO8601DateFormatter().date(from: "2020-10-07T14:35:50Z"))
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data {
            XCTAssertEqual(url.absoluteString, "file://foo/Info.json")
            XCTAssertEqual(options, [])
            
            return """
            {
                "keyVersion": 1,
                "itemVersion": 1,
                "id": "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A",
                "created": "2020-10-07T14:35:50Z"
            }
            """
        }
    }
    
    func testInfoNoData() async throws {
        let storeURL = URL(string: "file://foo")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let configuration = Store.Configuration(load: load)
        let store = Store(resourceLocator: resourceLocator, configuration: configuration)
        
        #warning("Workaround")
        do {
            _ = try await store.info
            XCTFail()
        } catch {}
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data {
            throw NSError()
        }
    }
    
    func testInfoInvalidData() async throws {
        let storeURL = URL(string: "file://foo")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let configuration = Store.Configuration(load: load)
        let store = Store(resourceLocator: resourceLocator, configuration: configuration)
        
        #warning("Workaround")
        do {
            _ = try await store.info
            XCTFail()
        } catch {}
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data {
            []
        }
    }
    
    func testDerivedKeyContainer() async throws {
        let storeURL = URL(string: "file://foo")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let configuration = Store.Configuration(load: load)
        let store = Store(resourceLocator: resourceLocator, configuration: configuration)
        let derivedKeyContainer = try await store.derivedKeyContainer
        
        XCTAssertEqual(derivedKeyContainer, Data(0...UInt8.max))
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data {
            XCTAssertEqual(url.absoluteString, "file://foo/DerivedKeyContainer")
            XCTAssertEqual(options, [])
            
            return Data(0...UInt8.max)
        }
    }
    
    func testDerivedKeyContainerNoData() async throws {
        let storeURL = URL(string: "file://foo")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let configuration = Store.Configuration(load: load)
        let store = Store(resourceLocator: resourceLocator, configuration: configuration)
        
        #warning("Workaround")
        do {
            _ = try await store.derivedKeyContainer
            XCTFail()
        } catch {}
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data {
            throw NSError()
        }
    }
    
    func testMasterKeyContainer() async throws {
        let storeURL = URL(string: "file://foo")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let configuration = Store.Configuration(load: load)
        let store = Store(resourceLocator: resourceLocator, configuration: configuration)
        let derivedKeyContainer = try await store.masterKeyContainer
        
        XCTAssertEqual(derivedKeyContainer, Data(0...UInt8.max))
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data {
            XCTAssertEqual(url.absoluteString, "file://foo/MasterKeyContainer")
            XCTAssertEqual(options, [])
            
            return Data(0...UInt8.max)
        }
    }
    
    func testMasterKeyContainerNoData() async throws {
        let storeURL = URL(string: "file://foo")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let configuration = Store.Configuration(load: load)
        let store = Store(resourceLocator: resourceLocator, configuration: configuration)
        
        #warning("Workaround")
        do {
            _ = try await store.masterKeyContainer
            XCTFail()
        } catch {}
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data {
            throw NSError()
        }
    }
    /*
    func testStoreLoadItem() {
        
    }
    
    func testStoreLoadItems() {
        
    }
    
    func testStoreExecute() {
        
    }
    
    func testStoreLoadStore() {
        
    }
    
    func testStoreLoadStoreContainerDirectoryDoesNotExist() {
        let containerURL = URL(string: "file:///vaults")!
        let storeID = UUID()
        let fileManager = FileManagerStub()
        fileManager.fileExistsContext = { _ in false }
        let finished = XCTestExpectation()
        Store.load(from: containerURL, matching: storeID, fileManager: fileManager)
            .assertNoFailure()
            .sink { store in
                XCTAssertNil(store)
                finished.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreLoadStoreContainerDirectoryReadFailure() {
        let containerURL = URL(string: "file:///vaults")!
        let storeID = UUID()
        let fileManager = FileManagerStub()
        fileManager.fileExistsContext = { _ in true }
        fileManager.contentsOfDirectoryContext = { _, _, _ in
            throw NSError()
        }
        let finished = XCTestExpectation()
        Store.load(from: containerURL, matching: storeID, fileManager: fileManager)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { store in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreLoadStoreInfoDataNotReadable() {
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data {
            throw NSError()
        }
        
        let containerURL = URL(string: "file:///vaults")!
        let storeID = UUID()
        let fileManager = FileManagerStub()
        fileManager.fileExistsContext = { _ in true }
        fileManager.contentsOfDirectoryContext = { _, _, _ in
            [containerURL.appendingPathComponent(UUID().uuidString, isDirectory: true)]
        }
        let finished = XCTestExpectation()
        Store.load(from: containerURL, matching: storeID, fileManager: fileManager, load: load)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { store in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreLoadStoreInfoDataNotDecodable() {
        
        func load(url: URL, options: Data.ReadingOptions) throws -> Data { .empty }
        
        let containerURL = URL(string: "file:///vaults")!
        let storeID = UUID()
        let fileManager = FileManagerStub()
        fileManager.fileExistsContext = { _ in true }
        fileManager.contentsOfDirectoryContext = { _, _, _ in
            [containerURL.appendingPathComponent(UUID().uuidString, isDirectory: true)]
        }
        let finished = XCTestExpectation()
        Store.load(from: containerURL, matching: storeID, fileManager: fileManager, load: load)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { store in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreCreateStore() {
        
        func writer(data: Data) -> (URL, Data.WritingOptions) throws -> Void {
            { _, _ in }
        }
        
        let containerURL = URL(string: "file:///vaults")!
        let fileManager = FileManagerStub()
        fileManager.createDirectoryContext = { _, _, _ in }
        let storeCreated = XCTestExpectation()
        
        Store.create(in: containerURL, derivedKeyContainer: .empty, masterKeyContainer: .empty, fileManager: fileManager, writer: writer)
            .assertNoFailure()
            .sink { store in
                storeCreated.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [storeCreated], timeout: .infinity)
    }
    
    func testStoreCreateStoreCreateContainerDirectoryFailure() {
        
        func writer(data: Data) -> (URL, Data.WritingOptions) throws -> Void {
            { _, _ in }
        }
        
        let containerURL = URL(string: "file:///vaults")!
        let fileManager = FileManagerStub()
        fileManager.createDirectoryContext = { url, _, _ in
            switch url.pathComponents {
            case ["/", "vaults"]:
                throw NSError()
            default:
                return
            }
        }
        let finished = XCTestExpectation()
        
        Store.create(in: containerURL, derivedKeyContainer: .empty, masterKeyContainer: .empty, fileManager: fileManager, writer: writer)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { _ in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreCreateStoreCreateStoreDirectoryFailure() {
        
        func writer(data: Data) -> (URL, Data.WritingOptions) throws -> Void {
            { _, _ in }
        }
        
        let containerURL = URL(string: "file:///vaults")!
        let fileManager = FileManagerStub()
        fileManager.createDirectoryContext = { url, _, _ in
            let storeID = url.pathComponents.indices.contains(2) ? url.pathComponents[2] : nil
            switch url.pathComponents {
            case ["/", "vaults", storeID]:
                throw NSError()
            default:
                return
            }
        }
        let finished = XCTestExpectation()
        
        Store.create(in: containerURL, derivedKeyContainer: .empty, masterKeyContainer: .empty, fileManager: fileManager, writer: writer)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { _ in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreCreateStoreCreateItemsDirectoryFailure() {
        
        func writer(data: Data) -> (URL, Data.WritingOptions) throws -> Void {
            { _, _ in }
        }
        
        let containerURL = URL(string: "file:///vaults")!
        let fileManager = FileManagerStub()
        fileManager.createDirectoryContext = { url, _, _ in
            let storeID = url.pathComponents.indices.contains(2) ? url.pathComponents[2] : nil
            switch url.pathComponents {
            case ["/", "vaults", storeID, "Items"]:
                throw NSError()
            default:
                return
            }
        }
        let finished = XCTestExpectation()
        
        Store.create(in: containerURL, derivedKeyContainer: .empty, masterKeyContainer: .empty, fileManager: fileManager, writer: writer)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { _ in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreCreateStoreWriteStoreInfoFailure() {
        
        func writer(data: Data) -> (URL, Data.WritingOptions) throws -> Void {
            { url, _ in
                switch url.lastPathComponent {
                case "Info.json":
                    throw NSError()
                default:
                    return
                }
            }
        }
        
        let containerURL = URL(string: "file:///vaults")!
        let fileManager = FileManagerStub()
        fileManager.createDirectoryContext = { _, _, _ in }
        let finished = XCTestExpectation()
        
        Store.create(in: containerURL, derivedKeyContainer: .empty, masterKeyContainer: .empty, fileManager: fileManager, writer: writer)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { _ in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreCreateStoreWriteDerivedKeyContainerFailure() {
        
        func writer(data: Data) -> (URL, Data.WritingOptions) throws -> Void {
            { url, _ in
                switch url.lastPathComponent {
                case "DerivedKeyContainer":
                    throw NSError()
                default:
                    return
                }
            }
        }
        
        let containerURL = URL(string: "file:///vaults")!
        let fileManager = FileManagerStub()
        fileManager.createDirectoryContext = { _, _, _ in }
        let finished = XCTestExpectation()
        
        Store.create(in: containerURL, derivedKeyContainer: .empty, masterKeyContainer: .empty, fileManager: fileManager, writer: writer)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { _ in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreCreateStoreWriteMasterKeyContainerFailure() {
        
        func writer(data: Data) -> (URL, Data.WritingOptions) throws -> Void {
            { url, _ in
                switch url.lastPathComponent {
                case "MasterKeyContainer":
                    throw NSError()
                default:
                    return
                }
            }
        }
        
        let containerURL = URL(string: "file:///vaults")!
        let fileManager = FileManagerStub()
        fileManager.createDirectoryContext = { _, _, _ in }
        let finished = XCTestExpectation()
        
        Store.create(in: containerURL, derivedKeyContainer: .empty, masterKeyContainer: .empty, fileManager: fileManager, writer: writer)
            .sink { completion in
                defer {
                    finished.fulfill()
                }
                
                guard case .failure = completion else {
                    XCTFail()
                    return
                }
            } receiveValue: { _ in
                XCTFail()
            }
            .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testDeletemItemOperationInitFromArray() {
        let url = URL(fileURLWithPath: "foo")
        let itemLocators = [
            Store.ItemLocator(url: url)
        ]
        let operation = Store.DeleteItemOperation(itemLocators)
        
        XCTAssertEqual(operation.itemLocators, itemLocators)
    }
    
    func testDeletemItemOperationInitFromArgumentList() {
        let url = URL(fileURLWithPath: "foo")
        let itemLocator = Store.ItemLocator(url: url)
        let operation = Store.DeleteItemOperation(itemLocator)
        
        XCTAssertEqual(operation.itemLocators, [itemLocator])
    }
    
    func testSaveItemOperationInitFromArray() throws {
        let password = try PasswordItem(password: "").encoded()
        let secureItem = try SecureItem(from: password, as: .password)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantFuture)
        let storeItems = [storeItem]
        let operation = Store.SaveItemOperation(storeItems) { _ in Data(0 ... UInt8.max) }
        let encryptedData = try operation.encrypt([])
        
        XCTAssertEqual(operation.storeItems, storeItems)
        XCTAssertEqual(encryptedData, Data(0 ... UInt8.max))
    }
    
    func testSaveItemOperationInitFromArgumentList() throws {
        let password = try PasswordItem(password: "").encoded()
        let secureItem = try SecureItem(from: password, as: .password)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantFuture)
        let operation = Store.SaveItemOperation(storeItem) { _ in Data(0 ... UInt8.max) }
        let encryptedData = try operation.encrypt([])
        
        XCTAssertEqual(operation.storeItems, [storeItem])
        XCTAssertEqual(encryptedData, Data(0 ... UInt8.max))
    }*/
    
}

/*
struct FileHandleStub: FileHandleRepresentable {
    
    let seekResult: Result<Void, Error>
    let readResult: Result<Data, Error>
    
    func seek(toOffset offset: UInt64) throws {
        try seekResult.get()
    }
    
    func read(upToCount count: Int) throws -> Data? {
        try readResult.get()
    }
    
}


class FileManagerStub: FileManagerRepresentable {
    
    var createDirectoryContext: ((URL, Bool, [FileAttributeKey : Any]?) throws -> Void)!
    var fileExistsContext: ((String) -> Bool)!
    var contentsOfDirectoryContext: ((URL, [URLResourceKey]?, FileManager.DirectoryEnumerationOptions) throws -> [URL])!
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        try createDirectoryContext(url, createIntermediates, attributes)
    }
    
    func fileExists(atPath path: String) -> Bool {
        fileExistsContext(path)
    }
    
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL] {
        try contentsOfDirectoryContext(url, keys, mask)
    }
    
}
*/
