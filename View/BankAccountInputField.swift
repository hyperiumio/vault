import Format
import SwiftUI

struct BankAccountInputField: View {
    
    @ObservedObject private var state: BankAccountItemState
    
    init(_ state: BankAccountItemState) {
        self.state = state
    }
    
    var body: some View {
        Field(.accountHolder) {
            TextField(.accountHolder, text: $state.accountHolder)
                #if os(iOS)
                .keyboardType(.namePhonePad)
                .textContentType(.name)
                #endif
        }
        
        Field(.iban) {
            TextField(.iban, value: $state.iban, format: .bankAccountNumber)
                .font(.body.monospaced())
                #if os(iOS)
                .keyboardType(.asciiCapable)
                #endif
        }
        
        Field(.bic) {
            TextField(.bic, text: $state.bic)
                .font(.body.monospaced())
                #if os(iOS)
                .keyboardType(.asciiCapable)
                #endif
        }
    }
    
}

#if DEBUG
struct BankAccountInputFieldPreview: PreviewProvider {
    
    static let state = BankAccountItemState()
    
    static var previews: some View {
        List {
            BankAccountInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            BankAccountInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
