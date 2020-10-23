import Localization
import SwiftUI

struct CreateVaultItemView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Group {
                        switch model.primaryItemModel {
                        case .login(let model):
                            EditLoginView(model)
                        case .password(let model):
                            PasswordEditView(model)
                        case .file(let model):
                            FileItemEditView(model)
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
                } header: {
                    VaultItemTitleView(LocalizedString.title, text: $model.title)
                        .padding()
                        .listRowInsets(.zero)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedString.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    SecureItemTypeView(model.primaryItemModel.secureItem.value.type)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedString.save, action: model.save)
                        .disabled(model.title.isEmpty)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}
