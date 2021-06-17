import SwiftUI

struct VaultItemView<S>: View where S: VaultItemStateRepresentable {
    
    @ObservedObject private var state: S
    @State private var mode = Mode.display
    
    init(_ state: S) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        Group {
            switch mode {
            case .display:
                VaultItemDisplayView(state)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(.edit) {
                                mode = .edit
                            }
                        }
                    }
            case .edit:
                VaultItemEditView(state)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(.cancel) {
                                state.discardChanges()
                                mode = .display
                            }
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button(.save) {
                                async {
                                    await state.save()
                                    mode = .display
                                }
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(mode == .edit)
            }
        }
        .transition(AnyTransition.opacity.animation(.easeInOut))
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        Group {
            switch mode {
            case .display:
                VaultItemDisplayView(state)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(.edit) {
                                mode = .edit
                            }
                        }
                    }
            case .edit:
                VaultItemEditView(state)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(.cancel) {
                                state.discardChanges()
                                mode = .display
                            }
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button(.save) {
                                state.save()
                                mode = .display
                            }
                        }
                    }
            }
        }
        .transition(AnyTransition.opacity.animation(.easeInOut))
    }
    #endif
    
}

private extension VaultItemView {
    
    enum Mode {
        
        case display
        case edit
        
    }
    
}

private struct VaultItemDisplayView<S>: View where S: VaultItemStateRepresentable {
    
    @ObservedObject var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        List {
            Section {
                ElementView(state.primaryItemState)
            } header: {
                Text(state.title)
                    .font(.title)
                    .textCase(.none)
   //                 .foregroundColor(.label)
                    .listRowInsets(EdgeInsets())
                    .padding()
            } footer: {
                VaultItemFooter(created: state.created, modified: state.modified)
            }
        }
        .listStyle(GroupedListStyle())
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        List {
            Section {
                ElementView(state.primaryItemState)
            } header: {
                Text(state.title)
                    .font(.title)
                    .textCase(.none)
               //     .foregroundColor(.label)
                    .listRowInsets(EdgeInsets())
                    .padding()
            } footer: {
                VaultItemFooter(created: state.created, modified: state.modified)
            }
        }
    }
    #endif
    
}

private struct VaultItemEditView<S>: View where S: VaultItemStateRepresentable {
    
    @ObservedObject private var state: S
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ state: S) {
        self.state = state
    }
    
    #if os(iOS)
    var body: some View {
        List {
            Group {
                Section {
                    ElementView(state.primaryItemState)
                } header: {
                    /*
                    TextFieldShim(title: .localizedTitle, text: $state.title, textStyle: .title1, alignment: .left)
                        .listRowInsets(EdgeInsets())
                        .padding()
                     */
                }
                
                Section {
                    Button(.deleteItem) {
                        async {
                            await state.delete()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        List {
            Group {
                Section {
                    ElementView(state.primaryItemState)
                } header: {
                    TextField(.title, text: $state.title)
                        .font(.title)
                        .listRowInsets(EdgeInsets())
                        .padding()
                }
                
                Section {
                    Button(.deleteItem) {
                        state.delete()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    #endif
    
}

private extension Section where Parent: View, Content: View, Footer == EmptyView {

    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) {
        self.init(header: header(), content: content)
    }
    
}

private extension Section where Parent: View, Content: View, Footer: View {
    
    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent, @ViewBuilder footer: () -> Footer) {
        self.init(header: header(), footer: footer(), content: content)
    }
    
}

private extension VaultItemDisplayView {

    struct ElementView: View {
        
        private let element: S.Element
        
        init(_ element: S.Element) {
            self.element = element
        }
        
        var body: some View {
            /*
            switch element {
            case .login(let state):
                LoginView(state.item)
            case .password(let state):
                PasswordView(state.item)
            case .file(let state):
                FileView(state.item)
            case .note(let state):
                NoteView(state.item)
            case .bankCard(let state):
                BankCardView(state.item)
            case .wifi(let state):
                WifiView(state.item)
            case .bankAccount(let state):
                BankAccountView(state.item)
            case .custom(let state):
                CustomView(state.item)
            }*/
            Text("foo")
        }
        
    }

}

private extension VaultItemEditView {

    struct ElementView: View {
        
        private let element: S.Element
        
        init(_ element: S.Element) {
            self.element = element
        }
        
        var body: some View {
            /*
            switch element {
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
             */
            Text("foo")
        }
        
    }

}
