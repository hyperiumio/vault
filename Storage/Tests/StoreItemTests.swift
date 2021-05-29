import XCTest
@testable import Storage

class StoreItemTests: XCTestCase {
    
    func testInitFromValues() {
        let id = UUID()
        let name = "foo"
        let loginItem = LoginItem(username: "", password: "", url: "")
        let passwordItem = PasswordItem(password: "")
        let primarySecureItem = SecureItem.login(loginItem)
        let secondarySecureItems = [
            SecureItem.password(passwordItem)
        ]
        let created = Date(timeIntervalSince1970: 0)
        let modified = Date(timeIntervalSince1970: 1)
        
        let storeItem = StoreItem(id: id, name: name, primaryItem: primarySecureItem, secondaryItems: secondarySecureItems, created: created, modified: modified)
        
        XCTAssertEqual(storeItem.id, id)
        XCTAssertEqual(storeItem.name, name)
        XCTAssertEqual(storeItem.primaryItem, primarySecureItem)
        XCTAssertEqual(storeItem.secondaryItems, secondarySecureItems)
        XCTAssertEqual(storeItem.created, created)
        XCTAssertEqual(storeItem.modified, modified)
    }
    
    func testPasswordDescription() throws {
        let referenceDate = Date(timeIntervalSince1970: 0)
        let password = try PasswordItem(password: "").encoded()
        let secureItem = try SecureItem(from: password, as: .password)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: referenceDate)
        
        XCTAssertEqual(storeItem.description, "1/1/70")
    }
    
    func testLoginDescription() throws {
        let login = try LoginItem(username: "foo", password: "", url: "").encoded()
        let secureItem = try SecureItem(from: login, as: .login)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)

        XCTAssertEqual(storeItem.description, "foo")
    }
    
    func testFileDescription() throws {
        let referenceData = Data(0 ... UInt8.max)
        let file = try FileItem(data: referenceData, typeIdentifier: .item).encoded()
        let secureItem = try SecureItem(from: file, as: .file)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(storeItem.description, "256 bytes")
    }
    
    func testNoteDescription() throws {
        let note = try NoteItem(text: "foo\nbar").encoded()
        let secureItem = try SecureItem(from: note, as: .note)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(storeItem.description, "foo")
    }
    
    func testNoteDescriptionNoText() throws {
        let note = try NoteItem(text: "").encoded()
        let secureItem = try SecureItem(from: note, as: .note)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertNil(storeItem.description)
    }
    
    func testBankCardDescription() throws {
        let bankCard = try BankCardItem(name: "foo", number: "", expirationDate: .distantPast, pin: "").encoded()
        let secureItem = try SecureItem(from: bankCard, as: .bankCard)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)

        XCTAssertEqual(storeItem.description, "foo")
    }
    
    func testWifiDescription() throws {
        let wifi = try WifiItem(name: "foo", password: "").encoded()
        let secureItem = try SecureItem(from: wifi, as: .wifi)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(storeItem.description, "foo")
    }
    
    func testBankAccountDescription() throws {
        let bankAccount = try BankAccountItem(accountHolder: "foo", iban: "", bic: "").encoded()
        let secureItem = try SecureItem(from: bankAccount, as: .bankAccount)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(storeItem.description, "foo")
    }
    
    func testCustomDescription() throws {
        let custom = try CustomItem(description: "foo", value: "").encoded()
        let secureItem = try SecureItem(from: custom, as: .custom)
        let storeItem = StoreItem(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(storeItem.description, "foo")
    }
    
    func testInfo() throws {
        let password = try PasswordItem(password: "").encoded()
        let secureItem = try SecureItem(from: password, as: .password)
        let storeItem = StoreItem(id: UUID(), name: "foo", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantFuture)
        let storeItemInfo = storeItem.info
        
        XCTAssertEqual(storeItemInfo.id, storeItem.id)
        XCTAssertEqual(storeItemInfo.name, "foo")
        XCTAssertEqual(storeItemInfo.primaryType, .password)
        XCTAssertTrue(storeItemInfo.secondaryTypes.isEmpty)
        XCTAssertEqual(storeItemInfo.created, .distantPast)
        XCTAssertEqual(storeItemInfo.modified, .distantFuture)
    }
    
}
