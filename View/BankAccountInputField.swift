import Asset
import Format
import SwiftUI

struct BankAccountInputField: View {
    
    @ObservedObject private var state: BankAccountItemState
    
    init(_ state: BankAccountItemState) {
        self.state = state
    }
    
    var body: some View {
        Field(Localized.accountHolder) {
            TextField(Localized.accountHolder, text: $state.accountHolder)
                #if os(iOS)
                .keyboardType(.namePhonePad)
                .textContentType(.name)
                #endif
        }
        
        Field(Localized.iban) {
            TextField(Localized.iban, value: $state.iban, format: .bankAccountNumber)
                .font(.body.monospaced())
                #if os(iOS)
                .keyboardType(.asciiCapable)
                #endif
        }
        
        Field(Localized.bic) {
            TextField(Localized.bic, text: $state.bic)
                .font(.body.monospaced())
                #if os(iOS)
                .keyboardType(.asciiCapable)
                #endif
        }
    }
    
}
