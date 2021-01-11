import Combine
import XCTest
@testable import Storage

class StoreTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    let store: Store = {
        let storeURL = URL(string: "file://foo/bar")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        return Store(resourceLocator: resourceLocator)
    }()
    
    func testStoreInitFromValues() {
        let storeURL = URL(string: "file://foo/bar")!
        let resourceLocator = StoreResourceLocator(storeURL: storeURL)
        let store = Store(resourceLocator: resourceLocator)
        
        XCTAssertEqual(store.resourceLocator.storeURL, resourceLocator.storeURL)
    }
    
    func testLoadInfo() {
        let finished = XCTestExpectation()
        
        store.loadInfo { url, _ in
            """
            {
              "keyVersion": 1,
              "itemVersion": 1,
              "id": "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A",
              "created": "2020-10-07T14:35:50Z"
            }
            """.data(using: .utf8)!
        }
        .sink { completion in
            defer {
                finished.fulfill()
            }
            
            guard case .finished = completion else {
                XCTFail()
                return
            }
        } receiveValue: { info in
            XCTAssertEqual(info.keyVersion, 1)
            XCTAssertEqual(info.itemVersion, 1)
            XCTAssertEqual(info.id.uuidString, "145E33F1-6CE9-4BFF-B261-3D5E71F8C50A")
            XCTAssertEqual(info.created, ISO8601DateFormatter().date(from: "2020-10-07T14:35:50Z"))
        }
        .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreLoadInfoNoData() {
        let finished = XCTestExpectation()
        
        store.loadInfo { url, _ in
            throw NSError()
        }
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
    
    func testStoreLoadInfoInvalidData() {
        let finished = XCTestExpectation()
        
        store.loadInfo { url, _ in
            Data()
        }
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
    
    func testStoreLoadDerivedKeyContainer() {
        let finished = XCTestExpectation()
        
        store.loadDerivedKeyContainer { url, _ in
            Data(0 ... UInt8.max)
        }
        .sink { completion in
            defer {
                finished.fulfill()
            }
            
            guard case .finished = completion else {
                XCTFail()
                return
            }
        } receiveValue: { data in
            XCTAssertEqual(data, Data(0 ... UInt8.max))
        }
        .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreLoadDerivedKeyContainerNoData() {
        let finished = XCTestExpectation()
        
        store.loadDerivedKeyContainer { url, _ in
            throw NSError()
        }
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
    
    func testStoreLoadMasterKeyContainer() {
        let finished = XCTestExpectation()
        
        store.loadMasterKeyContainer { url, _ in
            Data(0 ... UInt8.max)
        }
        .sink { completion in
            defer {
                finished.fulfill()
            }
            
            guard case .finished = completion else {
                XCTFail()
                return
            }
        } receiveValue: { data in
            XCTAssertEqual(data, Data(0 ... UInt8.max))
        }
        .store(in: &subscriptions)
        
        wait(for: [finished], timeout: .infinity)
    }
    
    func testStoreLoadMasterKeyContainerNoData() {
        let finished = XCTestExpectation()
        
        store.loadMasterKeyContainer { url, _ in
            throw NSError()
        }
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
    
    func testReadingContextInit() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        
        XCTAssertEqual(context.itemLocator, locator)
    }
    
    func testReadingContextInvalidFileHandle() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        let fileHandleFailure = { _ in
            throw NSError()
        } as (URL) throws -> FileHandleRepresentable
        
        XCTAssertThrowsError(try context.bytes(in: 0 ..< 1, fileHandle: fileHandleFailure))
    }
    
    func testReadingContextInvalidStartIndex() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        let fileHandleStub = { _ in
            FileHandleStub(seekResult: .success(()), readResult: .success(Data()))
        } as (URL) throws -> FileHandleRepresentable
        
        XCTAssertThrowsError(try context.bytes(in: -1 ..< 1, fileHandle: fileHandleStub))
    }
    
    func testReadingContextSeekFailure() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        let fileHandleStub = { _ in
            FileHandleStub(seekResult: .failure(NSError()), readResult: .success(Data()))
        } as (URL) throws -> FileHandleRepresentable
        
        XCTAssertThrowsError(try context.bytes(in: 0 ..< 1, fileHandle: fileHandleStub))
    }
    
    func testReadingContextReadFailure() {
        let url = URL(fileURLWithPath: "foo")
        let locator = Store.ItemLocator(url: url)
        let context = Store.ReadingContext(locator)
        let fileHandleStub = { _ in
            FileHandleStub(seekResult: .success(()), readResult: .failure(NSError()))
        } as (URL) throws -> FileHandleRepresentable
        
        XCTAssertThrowsError(try context.bytes(in: 0 ..< 1, fileHandle: fileHandleStub))
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
    }
    
}

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

private extension Data {
    
    static var empty: Self { Self() }
    
}
