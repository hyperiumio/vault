#if DEBUG
import Crypto
import Model
import Preferences
import SwiftUI

struct SetupViewPreview: PreviewProvider {
    
    static let service = Service(store: SetupServiceStub.shared, defaults: SetupServiceStub.shared, security: SetupServiceStub.shared)
    static let state = SetupState(service: service) { derivedKey, masterKey, storeID in
        print(derivedKey, masterKey, storeID)
    }
    
    @State static var password = ""
    @State static var repeatedPassword = ""
    
    static var previews: some View {
        SetupView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SetupView(state)
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

struct SetupServiceStub: DefaultsService, SecurityService, StoreService  {
    
    var defaults: Defaults {
        get async {
            Defaults(isBiometricUnlockEnabled: false, activeStoreID: nil)
        }
    }
    
    func set(isBiometricUnlockEnabled: Bool) async {
        print(#function, isBiometricUnlockEnabled)
    }
    
    func set(activeStoreID: UUID) async {
        print(#function, activeStoreID)
    }
    
    func storeSecret<D>(_ secret: D, forKey key: String) async throws where D : ContiguousBytes {
        print(#function, secret, key)
    }
    
    func createKeySet(password: String) async throws -> KeySet {
        print(#function, password)
        let derivedKeyPublicArguments = try! DerivedKey.PublicArguments()
        let derivedKey = try! DerivedKey(from: "", with: derivedKeyPublicArguments)
        let derivedKeyContainer = Data()
        let masterKey = MasterKey()
        let masterKeyContainer = Data()
        return (derivedKey, masterKey, derivedKeyContainer, masterKeyContainer)
    }
    func createStore(derivedKeyContainer: Data, masterKeyContainer: Data) async throws -> UUID {
        print(#function, derivedKeyContainer, masterKeyContainer)
        return UUID()
    }
    
    static let shared = SetupServiceStub()
    
}
#endif
                
