import Localization
import SwiftUI

struct SetupView<Model>: View where Model: SetupModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack {
            Group {
                SecureField(LocalizedString.masterPassword, text: $model.password)
                    .frame(maxWidth: 220)
                
                SecureField(LocalizedString.repeatPassword, text: $model.repeatedPassword)
                    .frame(maxWidth: 220)
                
                Button(LocalizedString.createVault, action: model.createMasterKey)
            }
            .disabled(model.status == .loading)
            
            
            switch model.status {
            case .none:
                EmptyView()
            case .loading:
                ProgressView()
            case .passwordMismatch:
                Text(LocalizedString.passwordMismatch)
            case .insecurePassword:
                Text(LocalizedString.insecurePassword)
            case .vaultCreationFailed:
                Text(LocalizedString.vaultCreationFailed)
            }

        }
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}

#if DEBUG
struct SetupViewPreviews: PreviewProvider {
    
    static let model = SetupModelStub()
    
    static var previews: some View {
        SetupView(model)
    }
    
}
#endif
