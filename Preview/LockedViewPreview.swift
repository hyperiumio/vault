#if DEBUG
/*
import Crypto
import Model
import Preferences
import SwiftUI

struct LockedViewPreview: PreviewProvider {
    
    static let service = Service(store: LockedServiceStub.shared, defaults: LockedServiceStub.shared, security: LockedServiceStub.shared)
    static let state = LockedState(storeID: UUID(), service: service) { derivedKey, masterKey, storeID in
        
    }
    
    static var previews: some View {
        LockedView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        LockedView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}

struct LockedServiceStub: DefaultsService, SecurityService, StoreService  {
    
    var derivedKeyContainer: Data {
        Data()
    }
    
    var masterKeyContainer: Data {
        Data()
    }
    
    var keychainAvailability: KeychainAvailability {
        .enrolled(.touchID)
    }
    
    static let shared = LockedServiceStub()
    
}
 */
#endif
