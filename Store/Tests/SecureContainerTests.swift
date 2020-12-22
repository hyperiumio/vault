import XCTest
@testable import Storage

class SecureContainerTests: XCTestCase {
    
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
        
        let secureContainer = SecureContainer(id: id, name: name, primaryItem: primarySecureItem, secondaryItems: secondarySecureItems, created: created, modified: modified)
        
        XCTAssertEqual(secureContainer.id, id)
        XCTAssertEqual(secureContainer.name, name)
        XCTAssertEqual(secureContainer.primaryItem, primarySecureItem)
        XCTAssertEqual(secureContainer.secondaryItems, secondarySecureItems)
        XCTAssertEqual(secureContainer.created, created)
        XCTAssertEqual(secureContainer.modified, modified)
    }
    
    func testPasswordInfo() throws {
        let referenceDate = Date(timeIntervalSince1970: 0)
        let password = try PasswordItem(password: "").encoded()
        let secureItem = try SecureItem(from: password, as: .password)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: referenceDate)
        
        XCTAssertEqual(secureContainer.description, "1/1/70")
    }
    
    func testLoginInfo() throws {
        let login = try LoginItem(username: "foo", password: "", url: "").encoded()
        let secureItem = try SecureItem(from: login, as: .login)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)

        XCTAssertEqual(secureContainer.description, "foo")
    }
    
    func testFileInfo() throws {
        let referenceData = Data(0 ... UInt8.max)
        let file = try FileItem(data: referenceData, typeIdentifier: .item).encoded()
        let secureItem = try SecureItem(from: file, as: .file)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(secureContainer.description, "256 bytes")
    }
    
    func testNoteInfo() throws {
        let note = try NoteItem(text: "foo\nbar").encoded()
        let secureItem = try SecureItem(from: note, as: .note)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(secureContainer.description, "foo")
    }
    
    func testNoteInfoNoText() throws {
        let note = try NoteItem(text: "").encoded()
        let secureItem = try SecureItem(from: note, as: .note)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertNil(secureContainer.description)
    }
    
    func testBankCardInfo() throws {
        let bankCard = try BankCardItem(name: "foo", number: "", expirationDate: .distantPast, pin: "").encoded()
        let secureItem = try SecureItem(from: bankCard, as: .bankCard)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)

        XCTAssertEqual(secureContainer.description, "foo")
    }
    
    func testWifiInfo() throws {
        let wifi = try WifiItem(name: "foo", password: "").encoded()
        let secureItem = try SecureItem(from: wifi, as: .wifi)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(secureContainer.description, "foo")
    }
    
    func testBankAccountInfo() throws {
        let bankAccount = try BankAccountItem(accountHolder: "foo", iban: "", bic: "").encoded()
        let secureItem = try SecureItem(from: bankAccount, as: .bankAccount)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(secureContainer.description, "foo")
    }
    
    func testCustomInfo() throws {
        let custom = try CustomItem(description: "foo", value: "").encoded()
        let secureItem = try SecureItem(from: custom, as: .custom)
        let secureContainer = SecureContainer(id: UUID(), name: "", primaryItem: secureItem, secondaryItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(secureContainer.description, "foo")
    }
    
}
