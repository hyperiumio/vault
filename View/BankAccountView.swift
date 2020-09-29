import Localization
import SwiftUI

struct BankAccountDisplayView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        Group {
            SecureItemTextDisplayField(LocalizedString.bankAccountHolder, text: model.accountHolder)
            
            SecureItemTextDisplayField(LocalizedString.bankAccountIban, text: model.iban)
            
            SecureItemTextDisplayField(LocalizedString.bankAccountBic, text: model.bic)
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
            SecureItemTextEditField(LocalizedString.bankAccountHolder, text: $model.accountHolder)
            
            SecureItemTextEditField(LocalizedString.bankAccountIban, text: $model.iban)
            
            SecureItemTextEditField(LocalizedString.bankAccountBic, text: $model.bic)
        }
    }
    
}
