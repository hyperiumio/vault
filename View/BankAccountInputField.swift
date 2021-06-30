import Format
import SwiftUI

struct BankAccountInputField: View {
    
    @ObservedObject private var state: BankAccountState
    
    init(_ state: BankAccountState) {
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
