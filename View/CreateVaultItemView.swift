import SwiftUI

struct CreateVaultItemView<Model>: View where Model: VaultItemModelRepresentable {
    
    @ObservedObject private var model: Model
    @Environment(\.presentationMode) private var presentationMode
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        NavigationView {
            /*
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
                    TextField(.security, text: $model.title, prompt: nil)
                        .font(.title)
                        .padding()
                        .listRowInsets(EdgeInsets())
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Foo")
                    //SecureItemTypeView(model.primaryItemModel.secureItem.value.secureItemType)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    /*
                    Button(.save, role: nil) {
                        await model.save()
                    }
                    .disabled(model.title.isEmpty)
                     */
                }
            }
            .navigationBarTitleDisplayMode(.inline)
             */
        }

    }
    
}

private extension Section where Parent: View, Content: View, Footer == EmptyView {

    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) {
        self.init(header: header(), content: content)
    }
    
}

#if DEBUG
struct CreateVaultItemViewPreview: PreviewProvider {
    
    static let model: VaultItemModelStub = {
        let loginModel = LoginModelStub()
        let primaryItemModel = VaultItemModelStub.Element.login(loginModel)
        return VaultItemModelStub(primaryItemModel: primaryItemModel, secondaryItemModels: [])
    }()
    
    static var previews: some View {
        CreateVaultItemView(model)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
