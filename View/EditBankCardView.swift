import Format
import SwiftUI

#warning("Todo")
struct EditBankCardView<Model>: View where Model: BankCardModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        EditSecureItemTextField(.name, placeholder: .name, text: $model.name)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditSecureItemTextField(.number, placeholder: .number, text: $model.number, formatter: CreditCardNumberFormatter())
            .font(.system(.body, design: .monospaced))
            .keyboardType(.numberPad)
            .textContentType(.creditCardNumber)
        
        EditSecureItemDateField(.expirationDate, date: $model.expirationDate)
        
        EditSecureItemSecureTextField(.pin, placeholder: .pin, text: $model.pin, generatorAvailable: false)
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        EditSecureItemTextField(.name, placeholder: .name, text: $model.name)
        
        EditSecureItemTextField(.number, placeholder: .number, text: $model.number, formatter: CreditCardNumberFormatter())
            .font(.system(.body, design: .monospaced))
        
        EditSecureItemDateField(.expirationDate, date: $model.expirationDate)
        
        EditSecureItemSecureTextField(.pin, placeholder: .pin, text: $model.pin, generatorAvailable: false)
    }
    #endif
    
}

#if DEBUG
struct EditBankCardViewPreview: PreviewProvider {
    
    static let model = BankCardModelStub()
    
    static var previews: some View {
        Group {
            List {
                EditBankCardView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditBankCardView(model)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
