import Format
import SwiftUI
#warning("TODO")
struct BankCardInputField<S>: View where S: BankCardStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        fatalError()
        /*
        EditItemTextField(.name, placeholder: .name, text: $state.name)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditItemTextField(.number, placeholder: .number, text: $state.number)
            .font(.system(.body, design: .monospaced))
            .keyboardType(.numberPad)
            .textContentType(.creditCardNumber)
        
        EditItemDateField(.expirationDate, date: $state.expirationDate)
        
        EditItemSecureField(.pin, placeholder: .pin, text: $state.pin, generatorAvailable: false)
         */
    }
    
}

#if DEBUG
struct BankCardInputFieldPreview: PreviewProvider {
    
    static let state = BankCardStateStub()
    
    static var previews: some View {
        List {
            BankCardInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
