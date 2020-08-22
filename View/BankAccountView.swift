import Localization
import SwiftUI

struct BankAccountView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(title: LocalizedString.bankAccountHolder, text: $model.accountHolder, isEditable: isEditable)
            
            SecureItemTextField(title: LocalizedString.bankAccountIban, text: $model.iban, isEditable: isEditable)
            
            SecureItemSecureField(title: LocalizedString.bankAccountBic, text: $model.bic, isEditable: isEditable)
        }
    }
    
}

#if DEBUG
class BankAccountModelStub: BankAccountModelRepresentable {
    
    var accountHolder = "John Doe"
    var iban = "DE91 1000 0000 0123 4567 89"
    var bic = "12345678"
    
    func copyAccountHolderToPasteboard() {}
    func copyIbanToPasteboard() {}
    func copyBicToPasteboard() {}
    
}

struct BankAccountViewProvider: PreviewProvider {
    
    static let model = BankAccountModelStub()
    @State static var isEditable = false
    
    static var previews: some View {
        BankAccountView(model: model, isEditable: $isEditable)
    }
    
}
#endif
