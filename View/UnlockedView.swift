import Localization
import SwiftUI

struct UnlockedView<Model>: View where Model: UnlockedModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var selectionPresented = false
    
    #if os(iOS)
    @State private var settingsPresented = false
    #endif
    
    #if os(macOS)
    var body: some View {
        NavigationView {
            VaultItemList(model.itemCollation)
                .toolbar {
                    Spacer()
                    
                    CreateVaultItemButton(action: model.createVaultItem) {
                        Image.plus
                    }
                }
            
            EmptySelection()
        }
        .sheet(item: $model.creationModel, content: VaultItemSheet.init)
        .alert(item: $model.failure, content: Self.alert)
        .onAppear(perform: model.reload)
    }
    #endif
    
    #if os(iOS)
    var body: some View {
        NavigationView {
            VaultItemList(model.itemCollation, searchText: $model.searchText)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            settingsPresented = true
                        } label: {
                            Image.settings
                        }
                        .sheet(isPresented: $settingsPresented) {
                            SettingsView(model.settingsModel)
                        }
                        
                        Button(action: model.lockApp) {
                            Image.lock
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            selectionPresented = true
                        } label: {
                            Image.plus
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            
            EmptySelection()
        }
        .sheet(isPresented: $selectionPresented) {
            NavigationView {
                List(SecureItemTypeIdentifier.allCases) { typeIdentifier in
                    Button {
                        model.createVaultItem(with: typeIdentifier)
                    } label: {
                        Label {
                            Text(typeIdentifier.name)
                        } icon: {
                            typeIdentifier.image
                                .foregroundColor(typeIdentifier.color)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(LocalizedString.cancel) {
                            selectionPresented = false
                        }
                    }
                }
            }
            .sheet(item: $model.creationModel) { vaultItemModel in
                NavigationView {
                    VaultItemEditView(vaultItemModel)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(LocalizedString.cancel) {
                                    model.creationModel = nil
                                }
                            }
                            
                            ToolbarItem(placement: .confirmationAction) {
                                Button(LocalizedString.save) {
                                    vaultItemModel.save()
                                }
                            }
                        }
                }
            }
        }
        .alert(item: $model.failure, content: Self.alert)
    }
    #endif
    
    func dismissSheets() {
        selectionPresented = false
        settingsPresented = false
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}

private extension UnlockedView {
    
    static func alert(for failure: UnlockedFailure) -> Alert {
        switch failure {
        case .loadOperationFailed:
            let name = Text(LocalizedString.loadFailed)
            return Alert(title: name)
        case .deleteOperationFailed:
            let name = Text(LocalizedString.deleteFailed)
            return Alert(title: name)
        }
    }
    
}

private extension UnlockedView {
    
    struct VaultItemList: View {
        
        let itemCollation: Model.Collation?
        let searchText: Binding<String>
        
        var body: some View {
            if let collation = itemCollation {
                List {
                    SearchBar(text: searchText)
                    
                    ForEach(collation.sections) { section in
                        Section(header: Text(section.key)) {
                            ForEach(section.elements) { model in
                                NavigationLink(destination: VaultItemReferenceView(model)) {
                                        VaultItemInfoView(model.info.name, description: model.info.description, typeIdentifier: model.info.primaryTypeIdentifier)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle(LocalizedString.vault)
            } else {
                Text(LocalizedString.emptyVault)
                    .font(.title)
            }
        }
     
        init(_ itemCollation: Model.Collation?, searchText: Binding<String>) {
            self.itemCollation = itemCollation
            self.searchText = searchText
        }
        
    }
    
    struct EmptySelection: View {
        
        var body: some View {
            Text("Nothing Selected")
        }
        
    }
    
    #if os(macOS)
    struct VaultItemSheet: View {
        
        private let model: Model.VaultItemModel
        
        @Environment(\.presentationMode) private var presentationMode
        
        var body: some View {
            ScrollView {
                VStack {
                    VaultItemView(model, mode: .creation)
                    
                    HStack {
                        Spacer()
                        
                        Button(LocalizedString.cancel) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        Button(LocalizedString.save, action: model.save)
                    }
                }
                .padding()
            }
            .frame(minWidth: 300)
        }
        
        init(_ model: Model.VaultItemModel) {
            self.model = model
        }
        
    }
    #endif
    
}
