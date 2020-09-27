import Localization
import SwiftUI

struct BankAccountDisplayView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemSecureTextDisplayField(LocalizedString.bankAccountHolder, text: model.accountHolder)
            
            SecureItemSecureTextDisplayField(LocalizedString.bankAccountIban, text: model.iban)
            
            SecureItemSecureTextDisplayField(LocalizedString.bankAccountBic, text: model.bic)
        }
    }
    
}


struct BankAccountEditView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemSecureTextEditField(LocalizedString.bankAccountHolder, text: $model.accountHolder)
            
            SecureItemSecureTextEditField(LocalizedString.bankAccountIban, text: $model.iban)
            
            SecureItemSecureTextEditField(LocalizedString.bankAccountBic, text: $model.bic)
        }
    }
    
}
