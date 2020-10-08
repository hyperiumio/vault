import Localization
import SwiftUI

struct BankAccountDisplayView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextDisplayField(LocalizedString.bankAccountHolder, text: model.accountHolder)
        
        SecureItemTextDisplayField(LocalizedString.bankAccountIban, text: model.iban)
        
        SecureItemTextDisplayField(LocalizedString.bankAccountBic, text: model.bic)
    }
    
}


struct BankAccountEditView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextEditField(LocalizedString.bankAccountHolder, text: $model.accountHolder)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        SecureItemTextEditField(LocalizedString.bankAccountIban, text: $model.iban)
            .keyboardType(.asciiCapable)
        
        SecureItemTextEditField(LocalizedString.bankAccountBic, text: $model.bic)
            .keyboardType(.asciiCapable)
    }
    
}
