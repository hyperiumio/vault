import Combine
import Store

class BankCardDisplayModel: ObservableObject, Identifiable {
    
    @Published var pinSecureDisplay = true
    
    var name: String { bankCard.name }
    var vendor: BankCard.Vendor { bankCard.vendor }
    var number: String { bankCard.number }
    var validityDate: String { bankCard.validityDate }
    var validFrom: String { bankCard.validFrom }
    var pin: String { bankCard.pin }
    
    private let bankCard: BankCard
    
    init(_ bankCard: BankCard) {
        self.bankCard = bankCard
    }
}
