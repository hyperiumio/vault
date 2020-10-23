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
                        ToolbarItem(placement: .principal) {
                            SecureItemTypeView(model.primaryItemModel.secureItem.value.type)
                        }
                        
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

struct VaultItemDisplayView<Model>: View where Model: VaultItemModelRepresentable {
    
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

struct VaultItemEditView<Model>: View where Model: VaultItemModelRepresentable {
    
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
                        .padding()
                        .listRowInsets(.zero)
                }
                
                Section {
                    Button(LocalizedString.deleteItem) {
                        model.delete()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.appRed)
                    .padding()
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
}
#endif

private extension VaultItemView {
    
    enum Mode {
        
        case display
        case edit
        
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
                LoginView(model)
            case .password(let model):
                PasswordDisplayView(model)
            case .file(let model):
                FileItemDisplayView(model)
            case .note(let model):
                NoteDisplayView(model)
            case .bankCard(let model):
                BankCardDisplayView(model)
            case .wifi(let model):
                WifiDisplayView(model)
            case .bankAccount(let model):
                BankAccountDisplayView(model)
            case .custom(let model):
                CustomItemDisplayView(model)
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
                PasswordEditView(model)
            case .file(let model):
                FileItemEditView(model)
            case .note(let model):
                NoteEditView(model)
            case .bankCard(let model):
                BankCardEditView(model)
            case .wifi(let model):
                WifiEditView(model)
            case .bankAccount(let model):
                BankAccountEditView(model)
            case .custom(let model):
                CustomItemEditView(model)
            }
        }
        
    }

}
