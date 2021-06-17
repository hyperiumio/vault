import SwiftUI

struct CreateVaultItemView<S>: View where S: VaultItemStateRepresentable {
    
    @ObservedObject private var state: S
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        NavigationView {
            /*
            List {
                Section {
                    switch state.primaryItemState {
                    case .login(let state):
                        EditLoginView(state)
                    case .password(let state):
                        EditPasswordView(state)
                    case .file(let state):
                        EditFileView(state)
                    case .note(let state):
                        EditNoteView(state)
                    case .bankCard(let state):
                        EditBankCardView(state)
                    case .wifi(let state):
                        EditWifiView(state)
                    case .bankAccount(let state):
                        EditBankAccountView(state)
                    case .custom(let state):
                        EditCustomView(state)
                    }
                } header: {
                    TextField(.security, text: $state.title, prompt: nil)
                        .font(.title)
                        .padding()
                        .listRowInsets(EdgeInsets())
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Foo")
                    //SecureItemTypeView(state.primaryItemState.secureItem.value.secureItemType)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    /*
                    Button(.save, role: nil) {
                        await state.save()
                    }
                    .disabled(state.title.isEmpty)
                     */
                }
            }
            .navigationBarTitleDisplayMode(.inline)
             */
        }

    }
    
}

private extension Section where Parent: View, Content: View, Footer == EmptyView {

    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) {
        self.init(header: header(), content: content)
    }
    
}

#if DEBUG
struct CreateVaultItemViewPreview: PreviewProvider {
    
    static let state: VaultItemStateStub = {
        let loginState = LoginStateStub()
        let primaryItemState = VaultItemStateStub.Element.login(loginState)
        return VaultItemStateStub(primaryItemState: primaryItemState, secondaryItemStates: [])
    }()
    
    static var previews: some View {
        CreateVaultItemView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
