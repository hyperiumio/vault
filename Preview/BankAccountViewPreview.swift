#if DEBUG
import SwiftUI

struct BankAccountViewPreview: PreviewProvider {
    
    static let model = BankAccountModelStub(accountHolder: "", iban: "", bic: "")
    @State static var isEditable = false
    
    static var previews: some View {
        Group {
            BankAccountView(model, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            BankAccountView(model, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
