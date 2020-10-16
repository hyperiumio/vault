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
                            FileEditView(model)
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
                    TitleField(LocalizedString.title, text: $model.title)
                }
                .padding()
                .listRowInsets(.zero)
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

private struct TitleField: UIViewRepresentable {
    
    private let title: String
    private let text: Binding<String>

    init(_ title: String, text: Binding<String>) {
        self.title = title
        self.text = text
    }
    
    func makeUIView(context: UIViewRepresentableContext<TitleField>) -> UITextField {
        let textField = UITextField()
        textField.placeholder = title
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        textField.addTarget(context.coordinator, action: #selector(TitleFieldCoordinator.textFieldDidChange), for: .editingChanged)
        
        return textField
    }

    func makeCoordinator() -> TitleFieldCoordinator {
        return TitleFieldCoordinator(text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TitleField>) {
        uiView.text = text.wrappedValue
        
        if !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

private class TitleFieldCoordinator: NSObject, UITextFieldDelegate {
    
    let text: Binding<String>
    var didBecomeFirstResponder = false

    init(_ text: Binding<String>) {
        self.text = text
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        text.wrappedValue = textField.text ?? ""
    }

}
