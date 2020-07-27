import Localization
import SwiftUI

struct VaultItemEditView: View {
    
    @ObservedObject var model: VaultItemEditModel
    
    var body: some View {
        VStack {
            TextField(LocalizedString.title, text: $model.title)
                .padding()
            
            Form {
                ForEach(model.secureItemModels) { secureItemModel in
                    SecureItemEditView(secureItemModel: secureItemModel)
                        .padding()
                }
            }
            
            CreateVaultItemButton(action: model.addItem) {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
            
            HStack {
                Button(LocalizedString.cancel, action: model.cancel)
                Button(LocalizedString.save, action: model.save)
                    .disabled(!model.saveButtonEnabled)
            }
        }
        .disabled(model.isLoading)
        .alert(item: $model.errorMessage) { error in
            return .saveFailed
        }
    }
    
}

extension Alert {
    
    static var saveFailed: Self {
        let saveFailed = Text(LocalizedString.saveFailed)
        return Alert(title: saveFailed)
    }
    
}
