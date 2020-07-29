import Localization
import SwiftUI

struct BankCardDisplayView<Model>: View where Model: BankCardDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Section {
            SecureItemDisplayField(title: LocalizedString.bankCardName, content: model.name)
                .onTapGesture(perform: model.copyNameToPasteboard)
            
            BankCardVendorField(title: LocalizedString.bankCardVendor, vendor: model.vendor)
            
            SecureItemDisplayField(title: LocalizedString.bankCardNumber, content: model.number)
                .onTapGesture(perform: model.copyNumberToPasteboard)
            
            SecureItemDisplayDateField(title: LocalizedString.bankCardExpirationDate, date: model.expirationDate)
                .onTapGesture(perform: model.copyExpirationDateToPasteboard)
            
            SecureItemDisplaySecureField(title: LocalizedString.bankCardPin , content: model.pin)
                .onTapGesture(perform: model.copyPinToPasteboard)
        }
    }
    
}

#if DEBUG

class BankCardDisplayModelStub: BankCardDisplayModelRepresentable {
    
    var name = "John Doe"
    var vendor = BankCardVendor.visa
    var number = "1234567891234567"
    var expirationDate = Date()
    var pin = "123"
    
    func copyNameToPasteboard() {}
    func copyNumberToPasteboard() {}
    func copyExpirationDateToPasteboard() {}
    func copyPinToPasteboard() {}
    
}

struct BankCardDisplayViewPreview: PreviewProvider {
    
    static let model = BankCardDisplayModelStub()
    
    static var previews: some View {
        List {
            BankCardDisplayView(model: model)
        }
     //   .listStyle(GroupedListStyle())
    }

    
}
#endif
