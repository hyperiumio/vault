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
struct VaultItemDisplayView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        List {
            VaultItemHeader(model.name, typeIdentifier: model.primaryItemModel.secureItem.typeIdentifier)
            
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
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
#endif

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
                FileView(model)
            case .note(let model):
                NoteDisplayView(model)
            case .bankCard(let model):
                BankCardDisplayView(model)
            case .wifi(let model):
                WifiView(model)
            case .bankAccount(let model):
                BankAccountDisplayView(model)
            case .custom(let model):
                CustomItemDisplayView(model)
            }
        }
        
    }

}
