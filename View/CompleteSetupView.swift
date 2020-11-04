import Localization
import SwiftUI

struct CompleteSetupView<Model>: View where Model: CompleteSetupModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var error: CompleteSetupError?
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(LocalizedString.setupComplete)
                .font(.title)
            
            Spacer()
            
            Button(LocalizedString.createVault, action: model.createVault)
                .buttonStyle(ColoredButtonStyle(.accentColor, size: .large, expansion: .fill))
                .disabled(model.isLoading)
        }
        .onReceive(model.error) { error in
            self.error = error
        }
        .alert(item: $error) { error in
            let title = Self.title(for: error)
            return Alert(title: title)
        }

    }
    
}

private extension CompleteSetupView {
    
    static func title(for error: CompleteSetupError) -> Text {
        switch error {
        case .vaultCreationFailed:
            return Text(LocalizedString.vaultCreationFailed)
        }
    }
    
}

#if os(iOS) && DEBUG
struct CompleteSetupViewPreview: PreviewProvider {
    
    static let model = CompleteSetupModelStub()
    
    static var previews: some View {
        Group {
            CompleteSetupView(model)
                .preferredColorScheme(.light)
            
            CompleteSetupView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
