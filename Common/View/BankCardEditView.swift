import SwiftUI

struct BankCardEditView: View {
    
    @ObservedObject var model: BankCardEditModel
    
    var body: some View {
        return VStack {
            TextField(.bankCardNamePlaceholder, text: $model.name)
            model.type.map { type in
                BankCardTypeView(bankCardType: type)
            }
            TextField(.bankCardNumberPlaceholder, text: $model.number)
            TextField(.bankCardValidityDatePlaceholder, text: $model.validityDate)
            TextField(.bankCardValidFromPlaceholder, text: $model.validFrom)
            TextField(.bankCardPinPlaceholder, text: $model.pin)
        }
    }
    
}
