import Localization
import SwiftUI

struct VaultItemTitleField: View {
    
    let text: Binding<String>
    
    @Binding var isEditable: Bool
    
    var body: some View {
        TextField(LocalizedString.title, text: text)
            .font(.title3)
            .padding(.vertical)
            .disabled(!isEditable)
            
    }
    
}

struct VaultItemFooter: View {
    
    let created: Date
    let modified: Date
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .custom, spacing: 4) {
                HStack(alignment: .center) {
                    Text(LocalizedString.created)
                        .fontWeight(.semibold)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                        .alignmentGuide(.custom) { dimension in
                            dimension[HorizontalAlignment.trailing]
                        }
                        
                    Text(created, formatter: dateFormatter)
                }
                
                HStack {
                    Text(LocalizedString.modified)
                        .fontWeight(.semibold)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                        .alignmentGuide(.custom) { dimension in
                            dimension[HorizontalAlignment.trailing]
                        }
                    
                    Text(created, formatter: dateFormatter)
                }
            }
            .font(.caption)
            
            Spacer()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
}

private extension HorizontalAlignment {
    
    struct CustomAlignment: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
        
    }

    static let custom = HorizontalAlignment(CustomAlignment.self)
}


#if os(macOS)
struct VaultItemView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    @State private var isEditable = true
    @State private var isAddItemViewVisible = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 0) {
                VaultItemTitleField(text: $model.name, isEditable: $isEditable)
                
                Divider()
                
                SecureItemView(model: model.primaryItemModel, isEditable: $isEditable)
                
                ForEach(Array(model.secondaryItemModels.enumerated()), id: \.offset) { index, secureItemModel in
                    Divider()
                    
                    HStack(alignment: .top) {
                        SecureItemView(model: secureItemModel, isEditable: $isEditable)
                        
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
                
                Divider()
                
                Button {
                    isAddItemViewVisible = true
                } label: {
                    Image.plusCircle
                        .renderingMode(.original)
                        .imageScale(.large)
                }
                .padding(.vertical)
                .sheet(isPresented: $isAddItemViewVisible) {
                    NavigationView {
                        List(SecureItemType.allCases) { typeIdentifier in
                            Button {
                                model.addSecondaryItem(with: typeIdentifier)
                                isAddItemViewVisible = false
                            } label: {
                                Label {
                                    Text(typeIdentifier.name)
                                        .foregroundColor(.label)
                                } icon: {
                                    Image(typeIdentifier).foregroundColor(Color(typeIdentifier))
                                }
                            }
                        }
                      //  .listStyle(PlainListStyle())
                      //  .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(LocalizedString.addItem)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(LocalizedString.cancel) {
                                    isAddItemViewVisible = false
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
  //      .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SecureItemToolbarItem(type: model.primaryItemModel.typeIdentifier)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(LocalizedString.save) {
                    model.save()
                }
                .disabled(model.status != .saving && !model.name.isEmpty)
            }
        }
    }
    
}
#endif

#if os(iOS)
struct VaultItemView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject var model: Model
    @State private var isEditable = true
    @State private var isAddItemViewVisible = false
    
    private let mode: Mode
    
    var body: some View {
        ScrollView {
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
                        .padding(.vertical)
                    }
                }
                
                Divider()
                
                switch mode {
                case .creation, .edit:
                    Button {
                        isAddItemViewVisible = true
                    } label: {
                        Image.plusCircle
                            .renderingMode(.original)
                            .imageScale(.large)
                    }
                    .padding(.vertical)
                    .sheet(isPresented: $isAddItemViewVisible) {
                        NavigationView {
                            List(SecureItemTypeIdentifier.allCases) { typeIdentifier in
                                Button {
                                    model.addSecondaryItem(with: typeIdentifier)
                                    isAddItemViewVisible = false
                                } label: {
                                    Label {
                                        Text(typeIdentifier.name)
                                            .foregroundColor(.label)
                                    } icon: {
                                        Image(typeIdentifier).foregroundColor(Color(typeIdentifier))
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle(LocalizedString.addItem)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button(LocalizedString.cancel) {
                                        isAddItemViewVisible = false
                                    }
                                }
                            }
                        }
                    }
                case .display:
                    EmptyView()
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ElementToolbarItem(type: model.primaryItemModel.secureItem.typeIdentifier)
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(LocalizedString.save) {
                    model.save()
                }
                //.disabled(model.status != .saving && !model.name.isEmpty)
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

extension VaultItemView {
    
    enum Mode {
        
        case creation
        case display
        case edit
        
    }
    
}

private extension VaultItemView {
    
    struct ElementView: View {
        
        let element: Model.Element
        let isEditable: Binding<Bool>
        
        var body: some View {
            switch element {
            case .login(let model):
                LoginView(model, isEditable: isEditable)
            case .password(let model):
                PasswordView(model, isEditable: isEditable)
            case .file(let model):
                FileView(model: model, isEditable: isEditable)
            case .note(let model):
                NoteView(model, isEditable: isEditable)
            case .bankCard(let model):
                BankCardView(model, isEditable: isEditable)
            case .wifi(let model):
                WifiView(model, isEditable: isEditable)
            case .bankAccount(let model):
                BankAccountView(model, isEditable: isEditable)
            case .custom(let model):
                CustomItemView(model, isEditable: isEditable)
            }
        }
        
    }
    
    struct ElementToolbarItem: View {
        
        let type: SecureItemTypeIdentifier
        
        var body: some View {
            HStack {
                Image(type)
                    .foregroundColor(Color(type))
                
                Text(type.name)
            }
        }
        
    }
    
}
#endif
