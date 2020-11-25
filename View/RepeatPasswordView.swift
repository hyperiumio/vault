import Localization
import SwiftUI

struct RepeatPasswordView<Model>: View where Model: RepeatPasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var displayError: RepeatPasswordModelError?
    
    init(_ model: Model) {
        self.model = model
    }
    
    var enabledIntensions: Set<PageNavigationIntention> {
        model.repeatedPassword.isEmpty ? [.backward] : [.backward, .forward]
    }
    
    #if os(macOS)
    var body: some View {
        PageNavigationView(LocalizedString.continue, enabledIntensions: enabledIntensions) { intension in
            switch intension {
            case .forward:
                model.validatePassword()
            case .backward:
                model.dismiss()
            }
        } content: {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(LocalizedString.repeatMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(LocalizedString.repeatMasterPasswordDescription)
                        .font(.body)
                        .foregroundColor(.secondaryLabel)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                NativeTextField(title: LocalizedString.enterMasterPassword, text: $model.repeatedPassword, isSecure: true, textStyle: .title2, alignment: .center, action: model.validatePassword)
                    .frame(minHeight: TextStyle.title2.lineHeight)
                
                Spacer()
                
                Spacer()
            }
        }
        .onReceive(model.error) { error in
            displayError = error
        }
        .alert(item: $displayError) { error in
            switch error {
            case .invalidPassword:
                let title = Text(LocalizedString.invalidPassword)
                return Alert(title: title)
            }
        }
    }
    #endif
    
    #if os(iOS)
    var body: some View {
        PageNavigationView(LocalizedString.continue, enabledIntensions: enabledIntensions) { intension in
            switch intension {
            case .forward:
                model.validatePassword()
            case .backward:
                break
            }
        } content: {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(LocalizedString.repeatMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(LocalizedString.repeatMasterPasswordDescription)
                        .font(.body)
                        .foregroundColor(.secondaryLabel)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                SecureField(LocalizedString.enterMasterPassword, text: $model.repeatedPassword)
                    .textContentType(.oneTimeCode)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: TextStyle.title2.lineHeight)
                
                Spacer()
                
                Spacer()
                
            }
        }
        .onReceive(model.error) { error in
            displayError = error
        }
        .alert(item: $displayError) { error in
            switch error {
            case .invalidPassword:
                let title = Text(LocalizedString.invalidPassword)
                return Alert(title: title)
            }
        }
    }
    #endif
    
}

#if DEBUG
struct RepeatPasswordViewProvider: PreviewProvider {
    
    static let model = RepeatPasswordModelStub()
    
    static var previews: some View {
        Group {
            RepeatPasswordView(model)
                .preferredColorScheme(.light)
            
            RepeatPasswordView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
