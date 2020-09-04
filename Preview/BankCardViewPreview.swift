#if DEBUG
import SwiftUI

struct BankCardViewPreview: PreviewProvider {
    
    static let model = BankCardModelStub(name: "", vendor: nil, number: "", expirationDate: .distantFuture, pin: "")
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            BankCardView(model, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            BankCardView(model, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
