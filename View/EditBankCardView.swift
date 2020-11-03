import Localization
import SwiftUI

struct EditBankCardView<Model>: View where Model: BankCardModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextEditField(LocalizedString.bankCardName, placeholder: LocalizedString.bankCardName, text: $model.name)
            .keyboardType(.namePhonePad)
            .textContentType(.name)
        
        SecureItemTextEditField(LocalizedString.bankCardNumber, placeholder: LocalizedString.bankCardNumber, text: $model.number)
            .keyboardType(.numberPad)
            .textContentType(.creditCardNumber)
        
        SecureItemDateEditField(LocalizedString.bankCardExpirationDate, date: $model.expirationDate)
        
        SecureItemSecureTextEditField(LocalizedString.bankCardPin, placeholder: LocalizedString.bankCardPin, text: $model.pin, generatorAvailable: false)
    }
    
}
