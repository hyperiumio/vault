import Localization
import SwiftUI

struct BankCardEditView<Model>: View where Model: BankCardEditModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemEditField(title: LocalizedString.bankCardName, text: $model.name)
            
            if let vendor = model.vendor {
                Divider()
                
                BankCardVendorField(title: LocalizedString.bankCardVendor, vendor: vendor)
            }
            
            Divider()
            
            SecureItemEditField(title: LocalizedString.bankCardNumber, text: $model.number)
            
            Divider()
            
            SecureItemEditDateField(title: LocalizedString.bankCardExpirationDate, date: $model.expirationDate)
            
            Divider()
            
            SecureItemEditSecureField(title: LocalizedString.bankCardPin, text: $model.pin)
        }
    }
    
}

#if DEBUG
class BankCardEditModelStub: BankCardEditModelRepresentable {
    
    var name = ""
    var number = ""
    var expirationDate = Date()
    var pin = ""
    var vendor: BankCardVendor? = BankCardVendor.masterCard
    
}

struct BankCardEditViewProvider: PreviewProvider {
    
    static let model = BankCardEditModelStub()
    
    static var previews: some View {
        BankCardEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
