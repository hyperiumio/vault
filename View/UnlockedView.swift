import Localization
import SwiftUI

struct UnlockedView<Model>: View where Model: UnlockedModelRepresentable {
    
    @ObservedObject var model: Model
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
            Group {
                switch model.itemCollation.sections.isEmpty {
                case true:
                    Empty()
                case false:
                    VaultItemList(itemCollation: model.itemCollation)
                        .navigationTitle(LocalizedString.vault)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        settingsPresented = true
                    } label: {
                        Image.settings
                    }
                    
                    Button(action:  model.lockApp) {
                        Image.lock
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectionPresented = true
                    } label: {
                        Image.plus
                            .imageScale(.large)
                    }
                    .popover(isPresented: $selectionPresented) {
                        ForEach(SecureItemTypeIdentifier.allCases) { typeIdentifier in
                            Button {
                                model.createVaultItem(with: typeIdentifier)
                            } label: {
                                Image(typeIdentifier)
                                
                                Text(typeIdentifier.name)
                            }
                        }
                    }
                }
            }
            .sheet(item: $model.creationModel) { model in
                VaultItemView(model, mode: .creation)
            }
        }
        .sheet(isPresented: $settingsPresented) {
            SettingsView(model.settingsModel)
        }
        .alert(item: $model.failure) { failure in
            switch failure {
            case .loadOperationFailed:
                let name = Text(LocalizedString.loadFailed)
                return Alert(title: name)
            case .deleteOperationFailed:
                let name = Text(LocalizedString.deleteFailed)
                return Alert(title: name)
            }
        }
        .onAppear(perform: model.reload)
    }
    #endif
    
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
        
        let itemCollation: Model.Collation
        
        var body: some View {
            switch itemCollation.sections.isEmpty {
            case true:
                Text(LocalizedString.emptyVault)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            case false:
                List {
                    ForEach(itemCollation.sections) { section in
                        Section(header: Text(section.key)) {
                            ForEach(section.elements) { model in
                                NavigationLink(destination: VaultItemReferenceView(model)) {
                                        VaultItemInfoView(model.info.name, description: model.info.description, itemType: model.info.primaryTypeIdentifier)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle(LocalizedString.vault)
            }
        }
     
        init(_ itemCollation: Model.Collation) {
            self.itemCollation = itemCollation
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
