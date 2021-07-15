#if DEBUG
import Crypto
import SwiftUI

struct AppViewPreview: PreviewProvider {
    
    static let appDependency = AppService()
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

extension AppViewPreview {
    
    struct AppService: AppDependency {
        
        var needsSetup: Bool {
            true
        }
        
        var setupDependency: SetupDependency {
            SetupService()
        }
        
        var lockedDependency: LockedDependency {
            LockedService()
        }
        
        var unlockedDependency: UnlockedDependency {
            UnlockedService()
        }
        
    }
    
    struct SetupService: SetupDependency {

        var biometryType: BiometryType? {
            get async {
                nil
            }
        }
        
        func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws {}
        
    }
    
    struct LockedService: LockedDependency {

        
        
        var biometryType: BiometryType? {
            nil
        }
        
        func unlockWithPassword(_ password: String) async throws {}
        func unlockWithBiometry() async throws {}
        
    }
    
    struct UnlockedService: UnlockedDependency {
        
    }
    
}
#endif
