#if DEBUG
import SwiftUI

struct AppViewPreview: PreviewProvider {
 
    static let setupDependency = SetupDependencyStub()
    static let lockedDependency = LockedDependencyStub(keychainAvailability: .notAvailable)
    static let appDependency = AppDependencyStub(activeStoreID: nil, setupDependency: setupDependency, lockedDependency: lockedDependency)
    static let appState = AppState(dependency: appDependency)
    
    static var previews: some View {
        AppView(appState)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        AppView(appState)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
