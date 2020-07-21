import Localization
import SwiftUI

struct BankCardEditView: View {
    
    @ObservedObject var model: BankCardEditModel
    
    var body: some View {
        return VStack {
            TextField(LocalizedString.bankCardNamePlaceholder, text: $model.name)
            
            if let vendor = model.vendor {
                BankCardTypeView(vendor: vendor)
            }

            TextField(LocalizedString.bankCardNumberPlaceholder, text: $model.number)
            TextField(LocalizedString.bankCardValidityDatePlaceholder, text: $model.validityDate)
            TextField(LocalizedString.bankCardValidFromPlaceholder, text: $model.validFrom)
            TextField(LocalizedString.bankCardPinPlaceholder, text: $model.pin)
        }
    }
    
}
