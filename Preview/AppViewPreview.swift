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
    
    actor AppService: AppDependency {
        
        var needsSetup: Bool {
            get async throws {
                true
            }
        }
        
        nonisolated func setupDependency() -> SetupDependency {
            SetupService()
        }
        
        nonisolated func lockedDependency() -> LockedDependency {
            LockedService()
        }
        
        nonisolated func unlockedDependency() -> UnlockedDependency {
            UnlockedService()
        }
        
    }
    
    actor SetupService: SetupDependency {

        var biometryType: BiometryType? {
            get async {
                nil
            }
        }
        
        func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws {}
        
    }
    
    actor LockedService: LockedDependency {

        
        
        var biometryType: BiometryType? {
            get async {
                nil
            }
        }
        
        func unlockWithPassword(_ password: String) async throws {}
        func unlockWithBiometry() async throws {}
        
    }
    
    actor UnlockedService: UnlockedDependency {
        
    }
    
}
#endif
