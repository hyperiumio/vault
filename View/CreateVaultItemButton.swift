import Localization
import SwiftUI
import Store

#if os(macOS)
struct CreateVaultItemButton: View {
    
    let action: (SecureItem.TypeIdentifier) -> Void
    
    var body: some View {
        Menu {
            Button(LocalizedString.login, systemImage: "person.fill") { action(.login) }
            
            Button(LocalizedString.password, systemImage: "key.fill") { action(.password) }
            
            Button(LocalizedString.file, systemImage: "paperclip") { action(.file) }
            
            Button(LocalizedString.note, systemImage: "note.text") { action(.note) }
            
            Button(LocalizedString.bankCard, systemImage: "creditcard.fill") { action(.bankCard) }
            
            Button(LocalizedString.wifi, systemImage: "wifi") { action(.wifi) }
            
            Button(LocalizedString.bankAccount, systemImage: "dollarsign.circle.fill") { action(.bankAccount) }
            
            Button(LocalizedString.customField, systemImage: "scribble.variable") { action(.customField) }
        } label: {
            Image(systemName: "plus")
                .foregroundColor(.accentColor)
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .fixedSize()
    }
    
}
#endif

#if os(iOS)
struct CreateVaultItemButton: View {
    
    let action: (SecureItem.TypeIdentifier) -> Void
    
    @State private var isSheetVisible = false
    
    var body: some View {
        Button {
            isSheetVisible = true
        } label: {
            Image(systemName: "plus")
        }
        .actionSheet(isPresented: $isSheetVisible) {
            let buttons = [
                .default(Text(LocalizedString.login)) {
                    action(.login)
                },
                .default(Text(LocalizedString.password)) {
                    action(.password)
                },
                .default(Text(LocalizedString.file)) {
                    action(.file)
                },
                .default(Text(LocalizedString.note)) {
                    action(.note)
                },
                .default(Text(LocalizedString.bankCard)) {
                    action(.bankCard)
                },
                .default(Text(LocalizedString.wifi)) {
                    action(.wifi)
                },
                .default(Text(LocalizedString.bankAccount)) {
                    action(.bankAccount)
                },
                .default(Text(LocalizedString.customField)) {
                    action(.customField)
                },
                .cancel()
            ] as [ActionSheet.Button]
            return ActionSheet(title: Text("Select"), buttons: buttons)
        }
    }
    
}
#endif

private extension Button where Label == SwiftUI.Label<Text, Image> {
    
    init<S>(_ title: S, systemImage name: String, action: @escaping () -> Void) where S : StringProtocol {
        self = Button(action: action) {
            Label(title, systemImage: name)
        }
    }
    
}
