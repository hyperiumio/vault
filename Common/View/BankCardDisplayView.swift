import SwiftUI

struct BankCardDisplayView: View {
    
    @ObservedObject var model: BankCardDisplayModel
    
    var body: some View {
        return VStack {
            Text(model.name)
            Text(model.type)
            Text(model.number)
            Text(model.validityDate)
            Text(model.validFrom)
            Text(model.note)
            Text(model.pin)
        }
    }
    
}
