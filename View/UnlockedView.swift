import Localization
import SwiftUI

#if os(macOS)
struct UnlockedView<Model>: View where Model: UnlockedModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.itemCollation.sections) { section in
                    Section(header: Text(section.key)) {
                        ForEach(section.elements) { element in
                            VaultItemInfoView(element.info.name, description: element.info.description, itemType: element.info.primaryTypeIdentifier)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(LocalizedString.vault)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                    Button {
                        model.createVaultItem()
                    } label: {
                        Image.plus
                            .imageScale(.large)
                    }
                }
            }
            .sheet(item: $model.creationModel) { model in
                VaultItemCreationView(model: model)
            }
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
    
}
#endif

#if os(iOS)
struct UnlockedView<Model>: View where Model: UnlockedModelRepresentable {
    
    @ObservedObject var model: Model
    @State private var settingsPresented = false
    
    var body: some View {
        NavigationView {
            Group {
                switch model.itemCollation.sections.isEmpty {
                case true:
                    Empty(createItem: model.createVaultItem)
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
                    Button(action: model.createVaultItem) {
                        Image.plus
                            .imageScale(.large)
                    }
                }
            }
            .sheet(item: $model.creationModel) { model in
                VaultItemCreationView(model: model)
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
    
    init(_ model: Model) {
        self.model = model
    }
    
}
#endif

private extension UnlockedView {
    
    struct Empty: View {
        
        let createItem: () -> Void
        
        var body: some View {
            VStack {
                Text(LocalizedString.emptyVault)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                Button(LocalizedString.createItem, action: createItem)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding()
            }
            
        }
        
    }
    
    struct VaultItemList: View {
        
        let itemCollation: Model.Collation
        
        var body: some View {
            List {
                ForEach(itemCollation.sections) { section in
                    Section(header: Text(section.key)) {
                        ForEach(section.elements) { element in
                            VaultItemInfoView(element.info.name, description: element.info.description, itemType: element.info.primaryTypeIdentifier)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        
    }
    
}
