import Localization
import SwiftUI

struct BankAccountView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(LocalizedString.bankAccountHolder, text: $model.accountHolder, isEditable: isEditable)
            
            SecureItemTextField(LocalizedString.bankAccountIban, text: $model.iban, isEditable: isEditable)
            
            SecureItemSecureField(LocalizedString.bankAccountBic, text: $model.bic, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}

#if DEBUG
struct BankAccountViewPreviews: PreviewProvider {
    
    static let model = BankAccountModelStub(accountHolder: "", iban: "", bic: "")
    @State static var isEditable = false
    
    static var previews: some View {
        BankAccountView(model, isEditable: $isEditable)
    }
    
}
#endif
