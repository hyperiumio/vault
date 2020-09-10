import SwiftUI
import Store

extension Image {
    
    static let login = Image(systemName: "person.fill")
    static let password = Image(systemName: "key.fill")
    static let file = Image(systemName: "paperclip")
    static let note = Image(systemName: "note.text")
    static let bankCard = Image(systemName: "creditcard.fill")
    static let wifi = Image(systemName: "wifi")
    static let bankAccount = Image(systemName: "dollarsign.circle.fill")
    static let custom = Image(systemName: "scribble.variable")
    static let touchID = Image(systemName: "touchid")
    static let faceID = Image(systemName: "faceid")
    static let warning = Image(systemName: "exclamationmark.triangle.fill")
    static let masterPassword =  Image(systemName: "key.fill")
    static let hideSecret = Image(systemName: "eye.slash.fill")
    static let showSecret = Image(systemName: "eye.fill")
    static let plus = Image(systemName: "plus")
    static let plusCircle = Image(systemName: "plus.circle.fill")
    static let lock = Image(systemName: "lock.fill")
    static let settings = Image(systemName: "slider.horizontal.3")
    static let trashCircle = Image(systemName: "trash.circle.fill")
    static let back = Image(systemName: "chevron.left.circle")
    static let done = Image(systemName: "checkmark.circle")
    
}

extension Image {
    
    init(_ secureItemType: SecureItem.TypeIdentifier) {
        switch secureItemType {
        case .password:
            self = .password
        case .login:
            self = .login
        case .file:
            self = .file
        case .note:
            self = .note
        case .bankCard:
            self = .bankCard
        case .wifi:
            self = .wifi
        case .bankAccount:
            self = .bankAccount
        case .custom:
            self = .custom
        }
    }
    
}
