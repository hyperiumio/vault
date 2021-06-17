import SwiftUI

struct ChoosePasswordView<Model>: View where Model: ChoosePasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        PageNavigationView(.continue, isEnabled: !model.password.isEmpty) {
            async {
                await model.choosePassword()
            }
        } content: {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(.chooseMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(.chooseMasterPasswordDescription)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                SecureField(.enterMasterPassword, text: $model.password, prompt: nil)
                    .textContentType(.oneTimeCode)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
    }
    
}

#if DEBUG
struct ChoosePasswordViewProvider: PreviewProvider {
    
    static let model = ChoosePasswordModelStub()
    
    static var previews: some View {
        ChoosePasswordView(model)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
