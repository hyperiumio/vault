import Localization
import SwiftUI

struct BankCardView<Model>: View where Model: BankCardModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(title: LocalizedString.bankCardName, text: $model.name, isEditable: isEditable)
            
            if let vendor = model.vendor {
                SecureItemBankCardVendorField(vendor: vendor)
            }
            
            SecureItemTextField(title: LocalizedString.bankCardNumber, text: $model.number, isEditable: isEditable)
            
            SecureItemDateField(title: LocalizedString.bankCardExpirationDate, date: $model.expirationDate, isEditable: isEditable)
            
            SecureItemSecureField(title: LocalizedString.bankCardPin, text: $model.pin, isEditable: isEditable)
        }
    }
    
}

#if DEBUG
class BankCardModelStub: BankCardModelRepresentable {
    
    var name = "John Doe"
    var vendor = BankCardVendor.visa as BankCardVendor?
    var number = "1234567891234567"
    var expirationDate = Date()
    var pin = "123"
    
    func copyNameToPasteboard() {}
    func copyNumberToPasteboard() {}
    func copyExpirationDateToPasteboard() {}
    func copyPinToPasteboard() {}
    
}

struct BankCardViewPreviewProvider: PreviewProvider {
    
    static let model = BankCardModelStub()
    @State static var isEditable = false
    
    static var previews: some View {
        List {
            BankCardView(model: model, isEditable: $isEditable)
        }
        .listStyle(GroupedListStyle())
    }
    
}
#endif
