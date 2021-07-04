#if DEBUG
import SwiftUI

struct SetupViewPreview: PreviewProvider {
    
    static let setupDependency = SetupDependencyStub()
    static let setupState = SetupState(dependency: setupDependency) { masterKey, storeID in
        print(masterKey, storeID)
    }
    
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
#endif
                
