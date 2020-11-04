import Localization
import SwiftUI

#if os(iOS)
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
                    switch model.primaryItemModel {
                    case .login(let model):
                        EditLoginView(model)
                    case .password(let model):
                        EditPasswordView(model)
                    case .file(let model):
                        EditFileView(model)
                    case .note(let model):
                        EditNoteView(model)
                    case .bankCard(let model):
                        EditBankCardView(model)
                    case .wifi(let model):
                        EditWifiView(model)
                    case .bankAccount(let model):
                        EditBankAccountView(model)
                    case .custom(let model):
                        EditCustomView(model)
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
#endif

#if os(iOS) && DEBUG
struct CreateVaultItemViewPreview: PreviewProvider {
    
    static let model: VaultItemModelStub = {
        let loginModel = LoginModelStub()
        let primaryItemModel = VaultItemModelStub.Element.login(loginModel)
        return VaultItemModelStub(primaryItemModel: primaryItemModel, secondaryItemModels: [])
    }()
    
    static var previews: some View {
        Group {
            CreateVaultItemView(model)
                .preferredColorScheme(.light)
            
            CreateVaultItemView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
