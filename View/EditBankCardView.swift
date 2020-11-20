import Format
import Localization
import SwiftUI

struct EditBankCardView<Model>: View where Model: BankCardModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        EditSecureItemTextField(LocalizedString.name, placeholder: LocalizedString.name, text: $model.name)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditSecureItemTextField(LocalizedString.number, placeholder: LocalizedString.number, text: $model.number, formatter: CreditCardNumberFormatter())
            .font(.system(.body, design: .monospaced))
            .keyboardType(.numberPad)
            .textContentType(.creditCardNumber)
        
        EditSecureItemDateField(LocalizedString.expirationDate, date: $model.expirationDate)
        
        EditSecureItemSecureTextField(LocalizedString.pin, placeholder: LocalizedString.pin, text: $model.pin, generatorAvailable: false)
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        EditSecureItemTextField(LocalizedString.name, placeholder: LocalizedString.name, text: $model.name)
        
        EditSecureItemTextField(LocalizedString.number, placeholder: LocalizedString.number, text: $model.number, formatter: CreditCardNumberFormatter())
            .font(.system(.body, design: .monospaced))
        
        EditSecureItemDateField(LocalizedString.expirationDate, date: $model.expirationDate)
        
        EditSecureItemSecureTextField(LocalizedString.pin, placeholder: LocalizedString.pin, text: $model.pin, generatorAvailable: false)
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
