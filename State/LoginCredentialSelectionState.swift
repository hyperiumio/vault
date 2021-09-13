import Foundation
import Model
import Collection

@MainActor
class LoginCredentialSelectionState: ObservableObject {
    
    @Published private(set) var status = Status.empty
    @Published var searchText = ""
    
    init(service: AppServiceProtocol) {
        
    }
    
}

extension LoginCredentialSelectionState {
    
    typealias Collation = AlphabeticCollation<LoginCredential>
    
    enum Status {
        
        case empty
        case value(Collation)
        
    }
    
}
