import SwiftUI

struct VaultItemEditView: View {
    
    @ObservedObject var model: VaultItemEditModel
    
    var body: some View {
        return VStack {
            TextField(.title, text: $model.title)
                .padding()
            
            Form {
                ForEach(model.secureItemModels) { secureItemModel in
                    SecureItemEditView(secureItemModel: secureItemModel)
                        .padding()
                }
            }
            
            CreateVaultItemButton(action: model.addItem)
            
            HStack {
                Button(.cancel, action: model.cancel)
                Button(.save, action: model.save)
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
        let saveFailed = Text(.saveFailed)
        return Alert(title: saveFailed)
    }
    
}
