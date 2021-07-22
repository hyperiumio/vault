import Asset
import Format
import Model
import Pasteboard
import SwiftUI

struct BankAccountField: View {
    
    private let item: BankAccountItem
    
    init(_ item: BankAccountItem) {
        self.item = item
    }
    
    var body: some View {
        Group {
            if let accountHolder = item.accountHolder {
                Button {
                    Pasteboard.general.string = accountHolder
                } label: {
                    Field(Localized.accountHolder) {
                        Text(accountHolder)
                    }
                }
            }
            
            if let iban = item.iban {
                Button {
                    Pasteboard.general.string = iban
                } label: {
                    Field(Localized.iban) {
                        Text(iban, format: .bankAccountNumber)
                            .font(.body.monospaced())
                    }
                }
            }
            
            if let bic = item.bic {
                Button {
                    Pasteboard.general.string = bic
                } label: {
                    Field(Localized.bic) {
                        Text(bic)
                            .font(.body.monospaced())
                    }
                }
            }
        }
        .buttonStyle(.message(Localized.copied))
    }
    
}
