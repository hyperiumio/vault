import Combine
import Store

class BankCardDisplayModel: ObservableObject, Identifiable {
    
    @Published var pinSecureDisplay = true
    
    var name: String { bankCard.name }
    var vendor: BankCardItem.Vendor { bankCard.vendor }
    var number: String { bankCard.number }
    var validityDate: String { bankCard.validityDate }
    var validFrom: String { bankCard.validFrom }
    var pin: String { bankCard.pin }
    
    private let bankCard: BankCardItem
    
    init(_ bankCard: BankCardItem) {
        self.bankCard = bankCard
    }
}
