import Localization
import SwiftUI

struct BankCardEditView: View {
    
    @ObservedObject var model: BankCardEditModel
    
    var body: some View {
        return VStack {
            TextField(LocalizedString.bankCardName, text: $model.name)
            
            if let vendor = model.vendor {
                //BankCardVendorField(vendor: vendor)
            }
            
        }
    }
    
}
