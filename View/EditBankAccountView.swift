import Format
import Localization
import SwiftUI

#if os(iOS)
struct EditBankAccountView<Model>: View where Model: BankAccountModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        EditSecureItemTextField(LocalizedString.accountHolder, placeholder: LocalizedString.accountHolder, text: $model.accountHolder)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        EditSecureItemTextField(LocalizedString.iban, placeholder: LocalizedString.iban, text: $model.iban, formatter: BankAccountNumberFormatter())
            .font(.system(.body, design: .monospaced))
            .keyboardType(.asciiCapable)
        
        EditSecureItemTextField(LocalizedString.bic, placeholder: LocalizedString.bic, text: $model.bic)
            .keyboardType(.asciiCapable)
    }
    
}
#endif

#if os(iOS) && DEBUG
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
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
