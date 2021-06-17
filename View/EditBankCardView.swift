import Format
import SwiftUI

struct EditBankCardView<S>: View where S: BankCardStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        EditItemTextField(.name, placeholder: .name, text: $state.name)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditItemTextField(.number, placeholder: .number, text: $state.number, formatter: CreditCardNumberFormatter())
            .font(.system(.body, design: .monospaced))
            .keyboardType(.numberPad)
            .textContentType(.creditCardNumber)
        
        EditItemDateField(.expirationDate, date: $state.expirationDate)
        
        EditItemSecureField(.pin, placeholder: .pin, text: $state.pin, generatorAvailable: false)
    }
    
}

#if DEBUG
struct EditBankCardViewPreview: PreviewProvider {
    
    static let state = BankCardStateStub()
    
    static var previews: some View {
        List {
            EditBankCardView(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
