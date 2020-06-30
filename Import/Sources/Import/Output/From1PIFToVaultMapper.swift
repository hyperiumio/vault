import Foundation

func mapFrom1PIFToVault(_ onePIFObject: OnePIFObject) -> VaultItem {
    switch onePIFObject {
        
    case .login(let value):
        return loginToVaultItem(value)
    case .password(let value):
        return passwordToVaultItem(value)
    case .note(let value):
        return noteToVaultItem(value)
    case .general(let value):
        return generalToVaultItem(value)
    }
}

func mapFrom1PIFsToVaults(_ onePIFObjects: [OnePIFObject]) -> [VaultItem] {
    return onePIFObjects.map { onePIFObject in
       return mapFrom1PIFToVault(onePIFObject)
    }
}

func generalToVaultItem(_ value: Root1PIFObject<GeneralSecureContents>) -> VaultItem {
    guard let notesPlain = value.secureContents.notesPlain else {
            return VaultItem(title: value.title, secureItems: otherSecureItems(value))
    }
    let noteSecureItem = SecureItem.note(note: notesPlain)

    return VaultItem(title: value.title, secureItems: [noteSecureItem] + otherSecureItems(value))
}

func noteToVaultItem(_ value: Root1PIFObject<NoteSecureContents>) -> VaultItem {
    guard let notesPlain = value.secureContents.notesPlain else {
            return VaultItem(title: value.title, secureItems: otherSecureItems(value))
    }
    let noteSecureItem = SecureItem.note(note: notesPlain)

    return VaultItem.init(title: value.title, secureItems: [noteSecureItem] + otherSecureItems(value))
}

func passwordToVaultItem(_ value: Root1PIFObject<PasswordSecureContents>) -> VaultItem {
    let passwordSecureItem = SecureItem.password(password: value.secureContents.password)
    let noteSecureItem = SecureItem.note(note: value.secureContents.notesPlain!)

    return VaultItem.init(title: value.title, secureItems: [passwordSecureItem] + otherSecureItems(value) + [noteSecureItem])
}

func loginToVaultItem(_ value: Root1PIFObject<LoginSecureContents>) -> VaultItem {
    let loginSecureItem = SecureItem.login(username: loginUsername(value), password: loginPassword(value))
    
    return VaultItem.init(title: value.title, secureItems: [loginSecureItem] + otherSecureItems(value))
}

func loginUsername(_ value: Root1PIFObject<LoginSecureContents>) -> String {
    return value.secureContents.fields.first { loginField in
        return loginField.name == "username"
    }?.name ?? ""
}

func loginPassword(_ value: Root1PIFObject<LoginSecureContents>) -> String {
    return value.secureContents.fields.first { loginField in
        return loginField.name == "password"
    }?.name ?? ""
}

func otherSecureItems<SecureContentType>(_ value: Root1PIFObject<SecureContentType>) -> [SecureItem] where SecureContentType: Decodable & SectionContainer {
    return value.secureContents.sections?.flatMap { section in
        return section.fields?.map{ field in
            SecureItem.genericItem(key: field.n, value: field.v)
        } ?? []
    } ?? []
}
