import Localization
import SwiftUI

struct ConfirmPasswordView<Model>: View where Model: ConfirmPasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Text(LocalizedString.confirmPassword)
                .font(.title)
                .multilineTextAlignment(.center)
            Button(LocalizedString.continue, action: model.confirmPassword)
                .buttonStyle(ColoredButtonStyle(.accentColor))
        }
    }
    
}
