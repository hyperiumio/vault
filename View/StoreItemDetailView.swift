import SwiftUI

struct StoreItemDetailView: View {
    
    @ObservedObject private var state: StoreItemDetailState
    
    init(_ state: StoreItemDetailState) {
        self.state = state
    }
    
    var body: some View {
        switch state.mode {
        case .display:
            List {
                Section {
                    SecureItemField(state.primaryItem)
                } header: {
                    Text(state.title)
                        .textCase(.none)
                } footer: {
                    DateFooter(created: state.created, modified: state.modified)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(.edit) {
                        state.editMode()
                    }
                }
            }
        case .edit:
            List {
                Section {
                    SecureItemInputField(state.primaryItem)
                } header: {
                    TextField(.title, text: $state.title)
                        .textCase(.none)
                }
                
                Section {
                    Button(.deleteItem, role: .destructive) {
                        async {
                            try! await state.delete()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        state.discardChanges()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(.save) {
                        async {
                            try await state.save()
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

private extension StoreItemDetailView {
    
    @MainActor
    struct SecureItemField: View {
        
        private let element: StoreItemDetailState.Element
        
        init(_ element: StoreItemDetailState.Element) {
            self.element = element
        }
        
        var body: some View {
            switch element {
            case .login(let state):
                LoginField(username: state.username, password: state.password, url: state.url)
            case .password(let state):
                PasswordField(password: state.password)
            case .file(let state):
                FileField(data: state.data, typeIdentifier: state.typeIdentifier)
            case .note(let state):
                NoteField(text: state.text)
            case .bankCard(let state):
                BankCardField(name: state.name, vendor: nil, number: state.number, expirationDate: state.expirationDate, pin: state.pin)
            case .wifi(let state):
                WifiField(name: state.name, password: state.password)
            case .bankAccount(let state):
                BankAccountField(accountHolder: state.accountHolder, iban: state.iban, bic: state.bic)
            case .custom(let state):
                CustomField(description: state.description, value: state.value)
            }
        }
        
    }
    
    struct SecureItemInputField: View {
        
        private let element: StoreItemDetailState.Element
        
        init(_ element: StoreItemDetailState.Element) {
            self.element = element
        }
        
        var body: some View {
            switch element {
            case .login(let state):
                LoginInputField(state)
            case .password(let state):
                PasswordInputField(state)
            case .file(let state):
                FileInputField(state)
            case .note(let state):
                NoteInputField(state)
            case .bankCard(let state):
                BankCardInputField(state)
            case .wifi(let state):
                WifiInputField(state)
            case .bankAccount(let state):
                BankAccountInputField(state)
            case .custom(let state):
                CustomInputField(state)
            }
        }
        
    }

}
