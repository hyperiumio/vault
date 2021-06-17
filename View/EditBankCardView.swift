import Format
import SwiftUI

struct EditBankCardView<Model>: View where Model: BankCardModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        EditItemTextField(.name, placeholder: .name, text: $model.name)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditItemTextField(.number, placeholder: .number, text: $model.number, formatter: CreditCardNumberFormatter())
            .font(.system(.body, design: .monospaced))
            .keyboardType(.numberPad)
            .textContentType(.creditCardNumber)
        
        EditItemDateField(.expirationDate, date: $model.expirationDate)
        
        EditItemSecureField(.pin, placeholder: .pin, text: $model.pin, generatorAvailable: false)
    }
    
}

#if DEBUG
struct EditBankCardViewPreview: PreviewProvider {
    
    static let model = BankCardModelStub()
    
    static var previews: some View {
        List {
            EditBankCardView(model)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
