import Localization
import SwiftUI
import Store

struct CreateVaultItemButton<Label>: View where Label: View {
    
    let action: (SecureItem.TypeIdentifier) -> Void
    let label: Label
    
    init(action: @escaping (SecureItem.TypeIdentifier) -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        Menu {
            VaultItemButton(title: LocalizedString.login, systemImage: "person.fill", typeIdentifier: .login, action: action)
            
            VaultItemButton(title: LocalizedString.password, systemImage: "key.fill", typeIdentifier: .password, action: action)
            
            VaultItemButton(title: LocalizedString.file, systemImage: "paperclip", typeIdentifier: .file, action: action)
            
            VaultItemButton(title: LocalizedString.note, systemImage: "note.text", typeIdentifier: .note, action: action)
            
            VaultItemButton(title: LocalizedString.bankCard, systemImage: "creditcard.fill", typeIdentifier: .bankCard, action: action)
            
            VaultItemButton(title: LocalizedString.wifi, systemImage: "wifi", typeIdentifier: .wifi, action: action)
            
            VaultItemButton(title: LocalizedString.bankAccount, systemImage: "dollarsign.circle.fill", typeIdentifier: .bankAccount, action: action)
            
            VaultItemButton(title: LocalizedString.customField, systemImage: "scribble.variable", typeIdentifier: .customField, action: action)
        } label: {
            label
        }
    }
    
}


private struct VaultItemButton: View {
    
    let title: String
    let systemImage: String
    let typeIdentifier: SecureItem.TypeIdentifier
    let action: (SecureItem.TypeIdentifier) -> Void
    
    var body: some View {
        Button {
            action(typeIdentifier)
        } label: {
            Label(title, systemImage: systemImage)
        }
    }
    
}
