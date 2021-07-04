#if DEBUG
import SwiftUI

struct LockedViewPreview: PreviewProvider {
    
    static let lockedDependency = LockedDependencyStub(keychainAvailability: .notAvailable)
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
