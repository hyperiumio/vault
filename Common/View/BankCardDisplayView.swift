import SwiftUI

struct BankCardDisplayView: View {
    
    @ObservedObject var model: BankCardDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.name)
            BankCardTypeView(vendor: model.vendor)
            Text(model.number)
            Text(model.validityDate)
            Text(model.validFrom)
            SecureText(content: model.pin, secureDisplay: $model.pinSecureDisplay)
        }
    }
    
}
