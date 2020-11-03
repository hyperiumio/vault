import Localization
import SwiftUI

struct BankAccountView: View {
    
    private let item: BankAccountItem
    
    init(_ item: BankAccountItem) {
        self.item = item
    }
    
    var body: some View {
        if let accountHolder = item.accountHolder {
            SecureItemTextDisplayField(LocalizedString.bankAccountHolder, text: accountHolder)
        }
        
        if let iban = item.iban {
            SecureItemTextDisplayField(LocalizedString.bankAccountIban, text: iban)
        }
        
        if let bic = item.bic {
            SecureItemTextDisplayField(LocalizedString.bankAccountBic, text: bic)
        }
    }
    
}
