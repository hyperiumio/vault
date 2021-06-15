import Format
import SwiftUI

#warning("Todo")
struct EditBankAccountView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        EditSecureItemTextField(.accountHolder, placeholder: .accountHolder, text: $model.accountHolder)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditSecureItemTextField(.iban, placeholder: .iban, text: $model.iban, formatter: BankAccountNumberFormatter())
            .font(.system(.body, design: .monospaced))
            .keyboardType(.asciiCapable)
        
        EditSecureItemTextField(.bic, placeholder: .bic, text: $model.bic)
            .keyboardType(.asciiCapable)
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        EditSecureItemTextField(.accountHolder, placeholder: .accountHolder, text: $model.accountHolder)
        
        EditSecureItemTextField(.iban, placeholder: .iban, text: $model.iban, formatter: BankAccountNumberFormatter())
            .font(.system(.body, design: .monospaced))
        
        EditSecureItemTextField(.bic, placeholder: .bic, text: $model.bic)
    }
    #endif
    
}

#if DEBUG
struct EditBankAccountViewPreview: PreviewProvider {
    
    static let model = BankAccountModelStub()
    
    static var previews: some View {
        Group {
            List {
                EditBankAccountView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditBankAccountView(model)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
