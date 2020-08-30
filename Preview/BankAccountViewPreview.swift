#if DEBUG
import SwiftUI

struct BankAccountViewPreview: PreviewProvider {
    
    static let model = BankAccountModelStub(accountHolder: "", iban: "", bic: "")
    @State static var isEditable = false
    
    static var previews: some View {
        BankAccountView(model, isEditable: $isEditable)
    }
    
}
#endif
