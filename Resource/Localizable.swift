import SwiftUI

extension String {
    
    static var recoveryKey: Self {
        NSLocalizedString("RecoveryKey", comment: "")
    }
    
}

extension LocalizedStringKey {
    
    static var exportItemsDidFail: Self { "ExportItemsDidFail" }
    static var importItemsDidFail: Self { "ImportItemsDidFail" }
    static var createBackupDidFail: Self { "CreateBackupDidFail" }
    static var restoreBackupDidFail: Self { "RestoreBackupDidFail" }
    static var deleteAllDataDidFail: Self { "DeleteAllDataDidFail" }
    static var recoveryKeyDescription: Self { "RecoveryKeyDescription" }
    static var recoveryKey: Self { "RecoveryKey" }
    static var printRecoveryKey: Self { "PrintRecoveryKey" }
    static var loadingRecoveryKeyFailed: Self { "LoadingRecoveryKeyFailed" }
    static var generateRecoveryKeyQRCodeImageFailed: Self { "GenerateRecoveryKeyQRCodeImageFailed" }
    static var generateRecoveryKeyPDFFailed: Self { "GenerateRecoveryKeyPDFFailed" }
    static var clearPasteboard: Self { "ClearPasteboard" }
    static var clearPasteboardDescription: Self { "ClearPasteboardDescription" }
    static var hidePasswords: Self { "HidePasswords" }
    static var hidePasswordsDescription: Self { "HidePasswordsDescription" }
    static var extendedUnlockDescription: Self { "ExtendedUnlockDescription" }

    static var chooseMasterPasswordTitle: Self { "ChooseMasterPasswordTitle" }
    static var chooseMasterPasswordDescription: Self { "ChooseMasterPasswordDescription" }
    static var repeatMasterPasswordTitle: Self { "RepeatMasterPasswordTitle" }
    static var repeatMasterPasswordDescription: Self { "RepeatMasterPasswordDescription" }
    static var enterMasterPassword: Self { "EnterMasterPassword" }
    static var insecurePasswordTitle: Self { "InsecurePasswordTitle" }
    static var insecurePasswordDescription: Self { "InsecurePasswordDescription" }
    static var passwordMismatchTitle: Self { "PasswordMismatchTitle" }
    static var passwordMismatchDescription: Self { "PasswordMismatchDescription" }
    static var add: Self { "Add" }
    static var addItem: Self { "AddItem" }
    static var unlock: Self { "Unlock" }
    static var setupCompleteTitle: Self { "SetupCompleteTitle" }
    static var setupCompleteDescription: Self { "SetupCompleteDescription" }
    static var store: Self { "Store" }
    static var sync: Self { "Sync" }
    static var about: Self { "About" }
    static var system: Self { "System" }
    static var version: Self { "Version" }
    static var build: Self { "Build" }
    static var copyright: Self { "Copyright" }
    static var numberOfItem: Self { "NumberOfItems" }
    static var appleWatch: Self { "AppleWatch" }
    
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
    
    static var created: Self { "Created" }
    static var createItem: Self { "CreateItem" }
    static var createFirstItem: Self { "CreateFirstItem" }
    static var createVault: Self { "CreateVault" }

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
    static var enabledWatchUnlock: Self { "EnabledWatchUnlock" }
    static var enabledWatchUnlockDescription: Self { "EnabledWatchUnlockDescription" }
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
    static var storeInfos: Self { "StoreInfos" }
    static var importItems: Self { "ImportItems" }
    static var exportItems: Self { "ExportItems" }
    static var createBackup: Self { "CreateBackup" }
    static var restoreBackup: Self { "RestoreBackup" }
    static var deleteAllData: Self { "DeleteAllData" }
    static var deleteAllDataTitle: Self { "DeleteAllDataTitle" }
    static var deleteAllDataMessage: Self { "DeleteAllDataMessage" }
    static var deleteAllDataAction: Self { "DeleteAllDataAction" }

    static var masterPasswordChangeDidFail: Self { "MasterPasswordChangeDidFail" }
    static var modified: Self { "Modified" }
    static var newMasterPassword: Self { "NewMasterPassword" }
    static var note: Self { "Note" }
    static var notePlaceholder: Self { "NotePlaceholder" }
    static var numbers: Self { "Numbers" }
    static var other: Self { "Other" }
    static var password: Self { "Password" }
    
    static var photo: Self { "Photo" }
    static var retry: Self { "Retry" }
    static var save: Self { "Save" }
    static var saveFailed: Self { "SaveFailed" }
    static var search: Self { "Search" }
    static var selectCategory: Self { "SelectCategory" }
    static var settings: Self { "Settings" }
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
    static var noResultsFound: Self { "NoResultsFound" }
    static var security: Self { "Security" }
    static var characters: Self { "characters" }
    static var data: Self { "Data" }
    
}
