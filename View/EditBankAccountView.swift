import Localization
import SwiftUI

struct EditBankAccountView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextEditField(LocalizedString.bankAccountHolder, placeholder: LocalizedString.bankAccountHolder, text: $model.accountHolder)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        SecureItemTextEditField(LocalizedString.bankAccountIban, placeholder: LocalizedString.bankAccountIban, text: $model.iban)
            .keyboardType(.asciiCapable)
        
        SecureItemTextEditField(LocalizedString.bankAccountBic, placeholder: LocalizedString.bankAccountBic, text: $model.bic)
            .keyboardType(.asciiCapable)
    }
    
}
