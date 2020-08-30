#if DEBUG
import SwiftUI

struct BankCardViewPreview: PreviewProvider {
    
    static let model = BankCardModelStub(name: "", vendor: nil, number: "", expirationDate: .distantFuture, pin: "")
    @State static var isEditable = false
    
    static var previews: some View {
        BankCardView(model, isEditable: $isEditable)
    }
    
}
#endif
