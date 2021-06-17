import SwiftUI

struct RepeatPasswordView<S>: View where S: RepeatPasswordStateRepresentable {
    
    @ObservedObject private var state: S
    @State private var displayError: RepeatPasswordStateError?
    
    init(_ state: S) {
        self.state = state
    }
    
    var enabledIntensions: Set<PageNavigationIntention> {
        state.repeatedPassword.isEmpty ? [.backward] : [.backward, .forward]
    }
    
    #if os(iOS)
    var body: some View {
        PageNavigationView(.continue, enabledIntensions: enabledIntensions) { intension in
            switch intension {
            case .forward:
                async {
                    await state.validatePassword()
                }
            case .backward:
                break
            }
        } content: {
            VStack {
                Spacer()
                
                VStack(spacing: 10) {
                    Text(.repeatMasterPassword)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(.repeatMasterPasswordDescription)
                        .font(.body)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                SecureField(.enterMasterPassword, text: $state.repeatedPassword)
                    .textContentType(.oneTimeCode)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .frame(minHeight: TextStyle.title2.lineHeight)
                
                Spacer()
                
                Spacer()
                
            }
        }
        .alert(item: $displayError) { error in
            switch error {
            case .invalidPassword:
                let title = Text(.invalidPassword)
                return Alert(title: title)
            }
        }
    }
    #endif
    
}

#if os(macOS)
private typealias TextStyle = NSFont.TextStyle

private extension NSFont.TextStyle {
    
    var lineHeight: CGFloat {
        let font = NSFont.preferredFont(forTextStyle: self)
        return NSLayoutManager().defaultLineHeight(for: font)
    }
    
}
#endif
    
#if os(iOS)
private typealias TextStyle = UIFont.TextStyle

private extension UIFont.TextStyle {

    var lineHeight: CGFloat {
        UIFont.preferredFont(forTextStyle: self).lineHeight
    }
    
}
#endif

#if DEBUG
struct RepeatPasswordViewProvider: PreviewProvider {
    
    static let state = RepeatPasswordStateStub()
    
    static var previews: some View {
        RepeatPasswordView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
