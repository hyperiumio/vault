import Resource
import SwiftUI

struct StoreItemEditView: View {
    
    @ObservedObject private var state: StoreItemEditState
    private let cancel: () -> Void
    
    init(_ state: StoreItemEditState, cancel: @escaping () -> Void) {
        self.state = state
        self.cancel = cancel
    }
    
    var body: some View {
        List {
            Section {
                ElementView(state.primaryItem)
            } header: {
                TextField(Localized.title, text: $state.title)
                    .textCase(.none)
            }
            
            Section {
                Button(Localized.deleteItem, role: .destructive) {
                    Task {
                        await state.delete()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(Localized.cancel, action: cancel)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(Localized.save) {
                    Task {
                        try await state.save()
                    }
                }
            }
        }
        #if os(iOS)
        .navigationBarBackButtonHidden(true)
        #endif
    }
    
}

extension StoreItemEditView {
    
    struct ElementView: View {
        
        private let element: StoreItemEditState.Element
        
        init(_ element: StoreItemEditState.Element) {
            self.element = element
        }
        
        var body: some View {
            switch element {
            case .login(let loginState):
                LoginInputField(loginState)
            case .password(let passwordState):
                PasswordInputField(passwordState)
            case .file(let fileState):
                FileInputField(fileState)
            case .note(let noteState):
                NoteInputField(noteState)
            case .bankCard(let bankCardState):
                BankCardInputField(bankCardState)
            case .wifi(let wifiState):
                WifiInputField(wifiState)
            case .bankAccount(let bankAccountState):
                BankAccountInputField(bankAccountState)
            case .custom(let customState):
                CustomInputField(customState)
            }
        }
        
    }

}
