import XCTest
@testable import Store

class VaultItemTests: XCTestCase {
    
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
        
        let vaultItem = VaultItem(id: id, name: name, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems, created: created, modified: modified)
        
        XCTAssertEqual(vaultItem.id, id)
        XCTAssertEqual(vaultItem.name, name)
        XCTAssertEqual(vaultItem.primarySecureItem, primarySecureItem)
        XCTAssertEqual(vaultItem.secondarySecureItems, secondarySecureItems)
        XCTAssertEqual(vaultItem.created, created)
        XCTAssertEqual(vaultItem.modified, modified)
    }
    
    func testPasswordInfo() throws {
        let referenceDate = Date(timeIntervalSince1970: 0)
        let password = try PasswordItem(password: "").encoded()
        let secureItem = try SecureItem(from: password, as: .password)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: referenceDate)
        
        XCTAssertEqual(vaultItem.description, "1/1/70")
    }
    
    func testLoginInfo() throws {
        let login = try LoginItem(username: "foo", password: "", url: "").encoded()
        let secureItem = try SecureItem(from: login, as: .login)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)

        XCTAssertEqual(vaultItem.description, "foo")
    }
    
    func testFileInfo() throws {
        let referenceData = Data(0 ... UInt8.max)
        let file = try FileItem(name: "", data: referenceData).encoded()
        let secureItem = try SecureItem(from: file, as: .file)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(vaultItem.description, "256 bytes")
    }
    
    func testFileInfoNoData() throws {
        let file = try FileItem(name: "", data: nil).encoded()
        let secureItem = try SecureItem(from: file, as: .file)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertNil(vaultItem.description)
    }
    
    func testNoteInfo() throws {
        let note = try NoteItem(text: "foo\nbar").encoded()
        let secureItem = try SecureItem(from: note, as: .note)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(vaultItem.description, "foo")
    }
    
    func testNoteInfoNoText() throws {
        let note = try NoteItem(text: "").encoded()
        let secureItem = try SecureItem(from: note, as: .note)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertNil(vaultItem.description)
    }
    
    func testBankCardInfo() throws {
        let bankCard = try BankCardItem(name: "foo", number: "", expirationDate: .distantPast, pin: "").encoded()
        let secureItem = try SecureItem(from: bankCard, as: .bankCard)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)

        XCTAssertEqual(vaultItem.description, "foo")
    }
    
    func testWifiInfo() throws {
        let wifi = try WifiItem(networkName: "foo", networkPassword: "").encoded()
        let secureItem = try SecureItem(from: wifi, as: .wifi)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(vaultItem.description, "foo")
    }
    
    func testBankAccountInfo() throws {
        let bankAccount = try BankAccountItem(accountHolder: "foo", iban: "", bic: "").encoded()
        let secureItem = try SecureItem(from: bankAccount, as: .bankAccount)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(vaultItem.description, "foo")
    }
    
    func testCustomInfo() throws {
        let custom = try CustomItem(name: "foo", value: "").encoded()
        let secureItem = try SecureItem(from: custom, as: .custom)
        let vaultItem = VaultItem(id: UUID(), name: "", primarySecureItem: secureItem, secondarySecureItems: [], created: .distantPast, modified: .distantPast)
        
        XCTAssertEqual(vaultItem.description, "foo")
    }
    
}
