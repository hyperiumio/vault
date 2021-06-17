import Format
import SwiftUI

struct EditBankAccountView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        EditItemTextField(.accountHolder, placeholder: .accountHolder, text: $model.accountHolder)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditItemTextField(.iban, placeholder: .iban, text: $model.iban, formatter: BankAccountNumberFormatter())
            .font(.system(.body, design: .monospaced))
            .keyboardType(.asciiCapable)
        
        EditItemTextField(.bic, placeholder: .bic, text: $model.bic)
            .keyboardType(.asciiCapable)
    }
    
}

#if DEBUG
struct EditBankAccountViewPreview: PreviewProvider {
    
    static let model = BankAccountModelStub()
    
    static var previews: some View {
        List {
            EditBankAccountView(model)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
