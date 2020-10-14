import Localization
import SwiftUI

struct ChoosePasswordView<Model>: View where Model: ChoosePasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Text(LocalizedString.chooseMasterPassword)
                .font(.title)
                .multilineTextAlignment(.center)
            Button(LocalizedString.continue, action: model.done)
                .buttonStyle(ColoredButtonStyle(.accentColor, size: .large))
                .disabled(!model.passwordIsValid)
        }
    }
    
}
