import XCTest
@testable import Storage

class SecureItemTests: XCTestCase {
    
    func testValue() {
        let password = PasswordItem(password: "")
        let login = LoginItem(username: "", password: "", url: "")
        let file = FileItem(data: Data(), typeIdentifier: .item)
        let note = NoteItem(text: "")
        let bankCard = BankCardItem(name: "", number: "", expirationDate: .distantPast, pin: "")
        let wifi = WifiItem(name: "", password: "")
        let bankAccount = BankAccountItem(accountHolder: "", iban: "", bic: "")
        let custom = CustomItem(description: "", value: "")
        
        let passwordSecureItem = SecureItem.password(password)
        let loginSecureItem = SecureItem.login(login)
        let fileSecureItem = SecureItem.file(file)
        let noteSecureItem = SecureItem.note(note)
        let bankCardSecureItem = SecureItem.bankCard(bankCard)
        let wifiSecureItem = SecureItem.wifi(wifi)
        let bankAccountSecureItem = SecureItem.bankAccount(bankAccount)
        let customSecureItem = SecureItem.custom(custom)
        
        XCTAssertNotNil(passwordSecureItem.value as? PasswordItem)
        XCTAssertNotNil(loginSecureItem.value as? LoginItem)
        XCTAssertNotNil(fileSecureItem.value as? FileItem)
        XCTAssertNotNil(noteSecureItem.value as? NoteItem)
        XCTAssertNotNil(bankCardSecureItem.value as? BankCardItem)
        XCTAssertNotNil(wifiSecureItem.value as? WifiItem)
        XCTAssertNotNil(bankAccountSecureItem.value as? BankAccountItem)
        XCTAssertNotNil(customSecureItem.value as? CustomItem)
    }
    
    func testInitFromData() throws {
        let password = try PasswordItem(password: "").encoded()
        let login = try LoginItem(username: "", password: "", url: "").encoded()
        let file = try FileItem(data: Data(), typeIdentifier: .item).encoded()
        let note = try NoteItem(text: "").encoded()
        let bankCard = try BankCardItem(name: "", number: "", expirationDate: .distantPast, pin: "").encoded()
        let wifi = try WifiItem(name: "", password: "").encoded()
        let bankAccount = try BankAccountItem(accountHolder: "", iban: "", bic: "").encoded()
        let custom = try CustomItem(description: "", value: "").encoded()
        
        let passwordSecureItem = try SecureItem(from: password, as: .password)
        let loginSecureItem = try SecureItem(from: login, as: .login)
        let fileSecureItem = try SecureItem(from: file, as: .file)
        let noteSecureItem = try SecureItem(from: note, as: .note)
        let bankCardSecureItem = try SecureItem(from: bankCard, as: .bankCard)
        let wifiSecureItem = try SecureItem(from: wifi, as: .wifi)
        let bankAccountSecureItem = try SecureItem(from: bankAccount, as: .bankAccount)
        let customSecureItem = try SecureItem(from: custom, as: .custom)
        
        XCTAssertNotNil(passwordSecureItem.value as? PasswordItem)
        XCTAssertNotNil(loginSecureItem.value as? LoginItem)
        XCTAssertNotNil(fileSecureItem.value as? FileItem)
        XCTAssertNotNil(noteSecureItem.value as? NoteItem)
        XCTAssertNotNil(bankCardSecureItem.value as? BankCardItem)
        XCTAssertNotNil(wifiSecureItem.value as? WifiItem)
        XCTAssertNotNil(bankAccountSecureItem.value as? BankAccountItem)
        XCTAssertNotNil(customSecureItem.value as? CustomItem)
    }
    
    func testInitFromDataFailure() {
        let data = Data()
        
        XCTAssertThrowsError(try SecureItem(from: data, as: .password))
        XCTAssertThrowsError(try SecureItem(from: data, as: .login))
        XCTAssertThrowsError(try SecureItem(from: data, as: .file))
        XCTAssertThrowsError(try SecureItem(from: data, as: .note))
        XCTAssertThrowsError(try SecureItem(from: data, as: .bankCard))
        XCTAssertThrowsError(try SecureItem(from: data, as: .wifi))
        XCTAssertThrowsError(try SecureItem(from: data, as: .bankAccount))
        XCTAssertThrowsError(try SecureItem(from: data, as: .custom))
    }
    
    func testSecureItemType() {
        let secureItemValue = SecureItemValueStub()
        
        XCTAssertEqual(secureItemValue.secureItemType, .login)
    }
    
}

private struct SecureItemValueStub: SecureItemValue {
    
    static var secureItemType: SecureItemType { .login }
    
    func encoded() throws -> Data {
        Data()
    }
    
    init(from data: Data) throws {}
    init() {}
    
}
