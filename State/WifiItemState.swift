import Foundation
import Model

@MainActor
class WifiItemState: ObservableObject {
    
    @Published var name: String
    @Published var password: String
    
    let passwordGeneratorState: PasswordGeneratorState
    
    var item: WifiItem {
        WifiItem(name: name, password: password)
    }
    
    init(item: WifiItem? = nil, service: AppServiceProtocol) {
        self.name = item?.name ?? ""
        self.password = item?.password ?? ""
        self.passwordGeneratorState = PasswordGeneratorState(service: service)
    }
    
}
