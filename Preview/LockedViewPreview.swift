#if DEBUG
import Crypto
import SwiftUI

struct LockedViewPreview: PreviewProvider {
    
    static let keychainAvailability = KeychainAvailability.enrolled(.touchID)
    static let lockedDependency = LockServiceStub()
    static let lockedState = LockedState(dependency: lockedDependency) {
        print("done")
    }
    
    static var previews: some View {
        LockedView(lockedState)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        LockedView(lockedState)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}

extension LockedViewPreview {
    
    struct LockServiceStub: LockedDependency {
        
        var biometryType: BiometryType? {
            nil
        }
        
        func unlockWithPassword(_ password: String) async throws {}
        func unlockWithBiometry() async throws {}
        
    }
    
}
#endif
