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
            case .edit:
                VaultItemEditView(model)
            }
        }
        .transition(AnyTransition.opacity.animation(.easeInOut))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                switch mode {
                case .display:
                    EmptyView()
                case .edit:
                    Button(LocalizedString.cancel) {
                        mode = .display
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                switch mode {
                case .display:
                    Button(LocalizedString.edit) {
                        mode = .edit
                    }
                case .edit:
                    Button(LocalizedString.save) {
                        mode = .display
                        model.save()
                    }
                }
                
            }
        }
        .navigationBarBackButtonHidden(mode == .edit)
    }
    
}

struct VaultItemDisplayView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        List {
            VaultItemDisplayHeader(model.name, typeIdentifier: model.primaryItemModel.secureItem.typeIdentifier)
            
            Section(footer: VaultItemFooter(created: model.created, modified: model.modified).padding(.top)) {
                ElementView(model.primaryItemModel)
                
                ForEach(Array(model.secondaryItemModels.enumerated()), id: \.offset) { index, secureItemModel in
                    Divider()
                    
                    HStack(alignment: .top) {
                        ElementView(secureItemModel)
                        
                        Button {
                            model.deleteSecondaryItem(at: index)
                        } label: {
                            Image.trashCircle
                                .renderingMode(.original)
                                .imageScale(.large)
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
}

struct VaultItemEditView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Form {
            Section {
                VaultItemEditHeader(LocalizedString.title, text: $model.name, typeIdentifier: model.primaryItemModel.secureItem.typeIdentifier)
            }
            
            Section {
                ElementView(model.primaryItemModel)
                
                ForEach(Array(model.secondaryItemModels.enumerated()), id: \.offset) { index, secureItemModel in
                    Divider()
                    
                    HStack(alignment: .top) {
                        ElementView(secureItemModel)
                        
                        Button {
                            model.deleteSecondaryItem(at: index)
                        } label: {
                            Image.trashCircle
                                .renderingMode(.original)
                                .imageScale(.large)
                        }
                        .padding(.vertical)
                    }
                }
            }
            
            Section {
                Button(LocalizedString.delete) {
                    model.delete()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
