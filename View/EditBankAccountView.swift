import Format
import SwiftUI

struct EditBankAccountView<S>: View where S: BankAccountStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        EditItemTextField(.accountHolder, placeholder: .accountHolder, text: $state.accountHolder)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditItemTextField(.iban, placeholder: .iban, text: $state.iban)
            .font(.system(.body, design: .monospaced))
            .keyboardType(.asciiCapable)
        
        EditItemTextField(.bic, placeholder: .bic, text: $state.bic)
            .keyboardType(.asciiCapable)
    }
    
}

#if DEBUG
struct EditBankAccountViewPreview: PreviewProvider {
    
    static let state = BankAccountStateStub()
    
    static var previews: some View {
        List {
            EditBankAccountView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
