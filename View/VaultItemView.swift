import Localization
import SwiftUI

#if os(macOS)
struct VaultItemView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    @State private var isEditable = true
    
    private let mode: Mode
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            VaultItemTitleField(text: $model.name, isEditable: $isEditable)
            
            Divider()
            
            ElementView(element: model.primaryItemModel, isEditable: $isEditable)
            
            ForEach(Array(model.secondaryItemModels.enumerated()), id: \.offset) { index, secureItemModel in
                Divider()
                
                HStack(alignment: .top) {
                    ElementView(element: secureItemModel, isEditable: $isEditable)
                    
                    Button {
                        model.deleteSecondaryItem(at: index)
                    } label: {
                        Image.trashCircle
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            switch mode {
            case .creation, .edit:
                CreateVaultItemButton(action: model.addSecondaryItem) {
                    Image.plusCircle
                        .renderingMode(.original)
                        .imageScale(.large)
                }
            case .display:
                EmptyView()
            }
        }
    }
    
    init(_ model: Model, mode: Mode) {
        self.model = model
        self.mode = mode
        
        switch mode {
        case .creation, .edit:
            _isEditable = State(initialValue: true)
        case .display:
            _isEditable = State(initialValue: false)
        }
    }
    
}
#endif

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

struct VaultItemDisplayView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        List {
            Group {
                Section {
                    ElementView(model.primaryItemModel)
                } header: {
                    ElementHeader(title: model.name, itemType: model.primaryItemModel.secureItem.value.type)
                } footer: {
                    VaultItemFooter(created: model.created, modified: model.modified)
                }
            }
            .listRowInsets(EdgeInsets(.zero))
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
                    VaultItemEditHeader(LocalizedString.title, text: $model.name, itemType: model.primaryItemModel.secureItem.value.type)
                }
                
                Section {
                    ElementView(model.primaryItemModel)
                } header: {
                    ElementHeader(itemType: model.primaryItemModel.secureItem.value.type)
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
            .listRowInsets(EdgeInsets(.zero))

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
                LoginDisplayView(model)
            case .password(let model):
                PasswordDisplayView(model)
            case .file(let model):
                FileDisplayView(model)
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
                LoginEditView(model)
            case .password(let model):
                PasswordEditView(model)
            case .file(let model):
                FileEditView(model)
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

private struct ElementHeader: View {
    
    let title: String?
    let itemType: SecureItemType
    
    init(title: String? = nil, itemType: SecureItemType) {
        self.title = title
        self.itemType = itemType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = title {
                Text(title)
                    .textCase(.none)
                    .font(Font.largeTitle.bold())
                    .foregroundColor(.label)
                    .padding(.vertical)
            } else {
                Spacer()
            }
            
            Label {
                Text(itemType.name)
                    .foregroundColor(.secondaryLabel)
            } icon: {
                itemType.image
                    .foregroundColor(itemType.color)
            }
            .labelStyle(HeaderLabelStyle())
        }
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
    
}
