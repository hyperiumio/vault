#if DEBUG
import SwiftUI
import Crypto

struct LockedViewPreview: PreviewProvider {
    
    static let keychainAvailability = KeychainAvailability.enrolled(.touchID)
    static let lockedDependency = LockedDependencyStub(keychainAvailability: keychainAvailability)
    static let lockedState = LockedState(dependency: lockedDependency) { masterKey in
        print(masterKey)
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
#endif
