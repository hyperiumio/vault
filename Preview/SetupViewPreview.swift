#if DEBUG
import Crypto
import SwiftUI

struct SetupViewPreview: PreviewProvider {
    
    static let setupDependency = SetupServiceStub()
    static let setupState = SetupState(dependency: setupDependency)
    
    @State static var password = ""
    @State static var repeatedPassword = ""
    
    static var previews: some View {
        SetupView(setupState)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView(setupState)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            
        SetupView.ChooseMasterPasswordView(password: $password)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView.ChooseMasterPasswordView(password: $password)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        SetupView.RepeatPasswordView(repeatedPassword: $repeatedPassword)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView.RepeatPasswordView(repeatedPassword: $repeatedPassword)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        SetupView.CompleteSetupView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView.CompleteSetupView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}

extension SetupViewPreview {
    
    struct SetupServiceStub: SetupDependency {
        
        var biometryType: BiometryType? {
            nil
        }

        let biometryTypeAvailability = BiometryType.faceID as BiometryType?
        
        func createStore(isBiometryEnabled: Bool, masterPassword: String) async throws -> MasterKey {
            MasterKey()
        }
        
    }
    
}
#endif
