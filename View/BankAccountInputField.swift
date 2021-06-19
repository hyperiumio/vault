import Format
import SwiftUI

struct BankAccountInputField<BankAccountInputState>: View where BankAccountInputState: BankAccountStateRepresentable {
    
    @ObservedObject private var state: BankAccountInputState
    
    init(_ state: BankAccountInputState) {
        self.state = state
    }
    
    var body: some View {
        Field(.accountHolder) {
            TextField(.accountHolder, text: $state.accountHolder)
                .keyboardType(.namePhonePad)
                .textContentType(.name)
        }
        
        Field(.iban) {
            TextField(.iban, value: $state.iban, format: .bankAccountNumber)
                .font(.body.monospaced())
                .keyboardType(.asciiCapable)
        }
        
        Field(.bic) {
            TextField(.bic, text: $state.bic)
                .font(.body.monospaced())
                .keyboardType(.asciiCapable)
        }
    }
    
}

#if DEBUG
struct BankAccountInputFieldPreview: PreviewProvider {
    
    static let state = BankAccountStateStub()
    
    static var previews: some View {
        List {
            BankAccountInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
