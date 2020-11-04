import Localization
import SwiftUI

#if os(iOS)
struct VaultItemView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var mode = Mode.display
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            switch mode {
            case .display:
                VaultItemDisplayView(model)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(LocalizedString.edit) {
                                mode = .edit
                            }
                        }
                    }
            case .edit:
                VaultItemEditView(model)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(LocalizedString.cancel) {
                                model.discardChanges()
                                mode = .display
                            }
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button(LocalizedString.save) {
                                model.save()
                                mode = .display
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(mode == .edit)
            }
        }
        .transition(AnyTransition.opacity.animation(.easeInOut))
    }
    
}

private extension VaultItemView {
    
    enum Mode {
        
        case display
        case edit
        
    }
    
}

private struct VaultItemDisplayView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        List {
            Section {
                ElementView(model.primaryItemModel)
            } header: {
                Text(model.title)
                    .font(.title)
                    .textCase(.none)
                    .foregroundColor(.label)
                    .listRowInsets(.zero)
                    .padding()
            } footer: {
                VaultItemFooter(created: model.created, modified: model.modified)
            }
        }
        .listStyle(GroupedListStyle())
    }
    
}

private struct VaultItemEditView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        List {
            Group {
                Section {
                    ElementView(model.primaryItemModel)
                } header: {
                    VaultItemTitleView(LocalizedString.title, text: $model.title)
                        .listRowInsets(.zero)
                        .padding()
                }
                
                Section {
                    Button(LocalizedString.deleteItem) {
                        model.delete()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.appRed)
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
}

private extension VaultItemDisplayView {

    struct ElementView: View {
        
        private let element: Model.Element
        
        init(_ element: Model.Element) {
            self.element = element
        }
        
        var body: some View {
            switch element {
            case .login(let model):
                LoginView(model.item)
            case .password(let model):
                PasswordView(model.item)
            case .file(let model):
                FileView(model.item)
            case .note(let model):
                NoteView(model.item)
            case .bankCard(let model):
                BankCardView(model.item)
            case .wifi(let model):
                WifiView(model.item)
            case .bankAccount(let model):
                BankAccountView(model.item)
            case .custom(let model):
                CustomView(model.item)
            }
        }
        
    }

}

private extension VaultItemEditView {

    struct ElementView: View {
        
        private let element: Model.Element
        
        init(_ element: Model.Element) {
            self.element = element
        }
        
        var body: some View {
            switch element {
            case .login(let model):
                EditLoginView(model)
            case .password(let model):
                EditPasswordView(model)
            case .file(let model):
                EditFileView(model)
            case .note(let model):
                EditNoteView(model)
            case .bankCard(let model):
                EditBankCardView(model)
            case .wifi(let model):
                EditWifiView(model)
            case .bankAccount(let model):
                EditBankAccountView(model)
            case .custom(let model):
                EditCustomView(model)
            }
        }
        
    }

}
#endif
