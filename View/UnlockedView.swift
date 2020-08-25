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
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button {
                        settingsPresented = true
                    } label: {
                        Image.settings
                    }
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
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
    
}
#endif

#if DEBUG

#endif
