import Localization
import SwiftUI

struct BankCardView<Model>: View where Model: BankCardModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemTextField(LocalizedString.bankCardName, text: $model.name, isEditable: isEditable)
            
            if let vendor = model.vendor {
                SecureItemBankCardVendorField(vendor)
            }
            
            SecureItemTextField(LocalizedString.bankCardNumber, text: $model.number, isEditable: isEditable)
            
            SecureItemDateField(LocalizedString.bankCardExpirationDate, date: $model.expirationDate, isEditable: isEditable)
            
            SecureItemSecureField(LocalizedString.bankCardPin, text: $model.pin, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}
