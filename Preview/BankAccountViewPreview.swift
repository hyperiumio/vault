#if DEBUG
import SwiftUI

struct BankAccountViewPreview: PreviewProvider {
    
    static let editModel = BankAccountModelStub(accountHolder: "", iban: "", bic: "")
    
    static let displayModel = BankAccountModelStub(accountHolder: "John Doe", iban: "AA12123456789123456789123456789123", bic: "BBBBCCLLbbb")
    
    static var previews: some View {
        Group {
            BankAccountView(editModel, isEditable: .constant(true))
            
            BankAccountView(displayModel, isEditable: .constant(false))
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
