import SwiftUI

extension LocalizedStringKey {
    
    static var add: Self { "Add" }
    static var addItem: Self { "AddItem" }
    static var additionalItems: Self { "AdditionalItems" }
    static var americanExpress: Self { "AmericanExpress" }
    static var appLaunchFailure: Self { "AppLaunchFailure" }
    static var back: Self { "Back" }
    static var bankCard: Self { "BankCard" }
    static var name: Self { "Name" }
    static var number: Self { "Number" }
    static var expirationDate: Self { "ExpirationDate" }
    static var pin: Self { "PIN" }
    static var vendor: Self { "Vendor" }
    static var bankAccount: Self { "BankAccount" }
    static var accountHolder: Self { "AccountHolder" }
    static var iban: Self { "IBAN" }
    static var bic: Self { "BIC" }
    static var biometricNotEnrolled: Self { "BiometricNotEnrolled" }
    static var cancel: Self { "Cancel" }
    static var changeMasterPassword: Self { "ChangeMasterPassword" }
    static var changeMasterPasswordDescription: Self { "ChangeMasterPasswordDescription" }
    static var chooseMasterPassword: Self { "ChooseMasterPassword" }
    static var chooseMasterPasswordDescription: Self { "ChooseMasterPasswordDescription" }
    static var created: Self { "Created" }
    static var createItem: Self { "CreateItem" }
    static var createFirstItem: Self { "CreateFirstItem" }
    static var createVault: Self { "CreateVault" }
    static var repeatMasterPassword: Self { "RepeatMasterPassword" }
    static var repeatMasterPasswordDescription: Self { "RepeatMasterPasswordDescription" }
    static var `continue`: Self { "Continue" }
    static var copied: Self { "Copied" }
    static var currentMasterPassword: Self { "CurrentMasterPassword" }
    static var custom: Self { "Custom " }
    static var description: Self { "Description" }
    static var value: Self { "Value" }
    static var deleteItem: Self { "DeleteItem" }
    static var deleteConfirmation: Self { "DeleteConfirmation" }
    static var deleteFailed: Self { "DeleteFailed" }
    static var document: Self { "Document" }
    static var done: Self { "Done" }
    static var edit: Self { "Edit" }
    static var enable: Self { "Enable" }
    static var enableFaceIDUnlock: Self { "EnableFaceIDUnlock" }
    static var enableFaceIDUnlockDescription: Self { "EnableFaceIDUnlockDescription" }
    static var enableTouchIDUnlock: Self { "EnableTouchIDUnlock" }
    static var enableTouchIDUnlockDescription: Self { "EnableTouchIDUnlockDescription" }
    static var exampleURL: Self { "ExampleURL" }
    static var emptyVault: Self { "EmptyVault" }
    static var faceID: Self { "FaceID" }
    static var faceIDActivationFailed: Self { "FaceIDActivationFailed" }
    static var faceIDDeactivationFailed: Self { "FaceIDDeactivationFailed" }
    static var faceIDDescription: Self { "FaceIDDescription" }
    static var faceIDNotEnrolled: Self { "FaceIDNotEnrolled" }
    static var file: Self { "File" }
    static var filename: Self { "Filename" }
    static var generatePassword: Self { "GeneratePassword" }
    static var image: Self { "Image" }
    static var importFile: Self { "ImportFile" }
    static var importFileDescription: Self { "ImportFileDescription" }
    static var insecurePassword: Self { "InsecurePassword" }
    static var invalidCurrentPassword: Self { "InvalidCurrentPassword" }
    static var loadingVaultFailed: Self { "LoadingVaultFailed" }
    static var loadingVaultItemFailed: Self { "LoadingVaultItemFailed" }
    static var lockVault: Self { "LockVault" }
    static var lockVaultDescription: Self { "LockVaultDescription" }
    static var login: Self { "Login" }
    static var mastercard: Self { "Mastercard" }
    static var masterPassword: Self { "MasterPassword" }
    static var enterMasterPassword: Self { "EnterMasterPassword" }
    static var masterPasswordChangeDidFail: Self { "MasterPasswordChangeDidFail" }
    static var modified: Self { "Modified" }
    static var newMasterPassword: Self { "NewMasterPassword" }
    static var note: Self { "Note" }
    static var notePlaceholder: Self { "NotePlaceholder" }
    static var numbers: Self { "Numbers" }
    static var other: Self { "Other" }
    static var password: Self { "Password" }
    static var passwordMismatch: Self { "PasswordMismatch" }
    static var photo: Self { "Photo" }
    static var retry: Self { "Retry" }
    static var save: Self { "Save" }
    static var saveFailed: Self { "SaveFailed" }
    static var search: Self { "Search" }
    static var selectCategory: Self { "SelectCategory" }
    static var settings: Self { "Settings" }
    static var setupComplete: Self { "SetupComplete" }
    static var setUpLater: Self { "SetUpLater" }
    static var setUpTouchID: Self { "SetUpTouchID" }
    static var setUpFaceID: Self { "SetUpFaceID" }
    static var symbols: Self { "Symbols" }
    static var title: Self { "Title"}
    static var touchID: Self { "TouchID" }
    static var touchIDActivationFailed: Self { "TouchIDActivationFailed" }
    static var touchIDDeactivationFailed: Self { "TouchIDDeactivationFailed" }
    static var touchIDDescription: Self { "TouchIDDescription" }
    static var touchIDNotEnrolled: Self { "TouchIDNotEnrolled" }
    static var unlockFailed: Self { "UnlockFailed" }
    static var unlockVault: Self { "UnlockVault" }
    static var unlockWithTouchID: Self { "UnlockWithTouchID" }
    static var unlockWithTouchIDDescription: Self { "UnlockWithTouchIDDescription" }
    static var unlockWithFaceID: Self { "UnlockWithFaceID" }
    static var unlockWithFaceIDDescription: Self { "UnlockWithFaceIDDescription" }
    static var url: Self { "URL" }
    static var useFaceID: Self { "UseFaceID" }
    static var usePassword: Self { "UsePassword" }
    static var useTouchID: Self { "UseTouchID" }
    static var username: Self { "Username" }
    static var usernameOrEmail: Self { "UsernameOrEmail" }
    static var vault: Self { "Vault" }
    static var vaultCreationFailed: Self { "VaultCreationFailed" }
    static var visa: Self { "Visa" }
    static var wifi: Self { "Wifi" }
    static var invalidPassword: Self { "InvalidPassword" }
    static var nothingSelected: Self { "NothingSelected" }
    
}

extension String {
    
    static var localizedSearch: Self { NSLocalizedString("Search", comment: "") }
    static var localizedMasterPassword: Self { NSLocalizedString("MasterPassword", comment: "") }
    static var localizedEnterMasterPassword: Self { NSLocalizedString("EnterMasterPassword", comment: "") }
    static var localizedTitle: Self { NSLocalizedString("Title", comment: "") }
    static func localizedCharacters(_ count: Int) -> Self { localizedStringWithFormat("%d characters", count) }
    
}

enum SFSymbolName {
    
    static var personFill: String { "person.fill" }
    static var keyFill: String { "key.fill" }
    static var noteText: String { "note.text" }
    static var creditcard: String { "creditcard" }
    static var wifi: String { "wifi" }
    static var dollarsignCircle: String { "dollarsign.circle" }
    static var scribbleVariable: String { "scribble.variable" }
    static var touchid: String { "touchid" }
    static var faceid: String { "faceid" }
    static var exclamationmarkTriangle: String { "exclamationmark.triangle" }
    static var eyeSlash: String { "eye.slash" }
    static var eye: String { "eye" }
    static var plus: String { "plus" }
    static var lockFill: String { "lock.fill" }
    static var sliderHorizontal3: String { "slider.horizontal.3" }
    static var chevronLeftCircle: String { "chevron.left.circle" }
    static var chevronRightCircle: String { "chevron.right.circle" }
    static var magnifyingglass: String { "magnifyingglass" }
    static var paperclip: String { "paperclip" }
    static var camera: String { "camera" }
    static var docTextViewfinder: String { "doc.text.viewfinder" }
    static var photoOnRectangle: String { "photo.on.rectangle" }
    static var checkmarkCircle: String { "checkmark.circle" }
    static var exclamationmarkTriangleFill: String { "exclamationmark.triangle.fill" }
    
}


#if canImport(AppKit)
import AppKit

extension Color {
    
    static let systemBackground = Self(.textBackgroundColor)
    static let textFieldBackground = Self(.windowBackgroundColor)
    static let label = Self(.labelColor)
    static let secondaryLabel = Self(.secondaryLabelColor)
    static let tertiaryLabel = Self(.tertiaryLabelColor)
    static let quaternaryLabel = Self(.quaternaryLabelColor)
    
}

#endif

#if canImport(UIKit)
import UIKit

extension Color {
    
    static let systemBackground = Self(.systemBackground)
    static let textFieldBackground = Self(.secondarySystemBackground)
    static let label = Self(.label)
    static let secondaryLabel = Self(.secondaryLabel)
    static let tertiaryLabel = Self(.tertiaryLabel)
    static let quaternaryLabel = Self(.quaternaryLabel)
    
}
#endif
