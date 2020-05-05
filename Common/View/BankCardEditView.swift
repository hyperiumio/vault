import SwiftUI

struct BankCardEditView: View {
    
    @ObservedObject var model: BankCardEditModel
    
    var body: some View {
        return VStack {
            TextField(.bankCardNamePlaceholder, text: $model.name)
            TextField(.bankCardTypePlaceholder, text: $model.type)
            TextField(.bankCardNumberPlaceholder, text: $model.number)
            TextField(.bankCardValidityDatePlaceholder, text: $model.validityDate)
            TextField(.bankCardValidFromPlaceholder, text: $model.validFrom)
            TextField(.bankCardNotePlaceholder, text: $model.note)
            TextField(.bankCardPinPlaceholder, text: $model.pin)
        }
    }
    
}
