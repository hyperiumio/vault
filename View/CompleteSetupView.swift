import SwiftUI

#warning("Todo")
#if os(iOS)
private let feedbackGenerator = UINotificationFeedbackGenerator()
#endif

struct CompleteSetupView<Model>: View where Model: CompleteSetupModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var displayError: CompleteSetupModelError?
    @State private var isCheckmarkVisible = false
    
    init(_ model: Model) {
        self.model = model
    }
    
    var enabledIntensions: Set<PageNavigationIntention> {
        model.isLoading ? [.backward] : [.backward, .forward]
    }
    
    #if os(macOS)
    var body: some View {
        VStack {
            /*
            Spacer()
            
            if isCheckmarkVisible {
                VStack(spacing: 20) {
                    Text(.setupComplete)
                        .font(.title)
                        .zIndex(0)
                    
                    Image(systemName: SFSymbolName.checkmarkCircle)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                .transition(AnyTransition.scale(scale: 2).combined(with: .opacity).animation(Animation.easeIn(duration: 0.5)))
            }
            
            Spacer()
            
            Button(.createVault, action: model.createVault)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .disabled(!enabledIntensions.contains(.forward))
        }
        .padding()
        .onReceive(model.error) { error in
            displayError = error
        }
        .alert(item: $displayError) { error in
            switch error {
            case .vaultCreationFailed:
                let title = Text(.invalidPassword)
                return Alert(title: title)
            }
        }
        .onAppear {
            isCheckmarkVisible = true

        }
             */
        }

    }
    #endif
    
    #if os(iOS)
    var body: some View {
        VStack {
            Spacer()
            
            if isCheckmarkVisible {
                VStack(spacing: 20) {
                    Text(.setupComplete)
                        .font(.title)
                        .zIndex(0)
                    
                    Image(systemName: .checkmark)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                .transition(AnyTransition.scale(scale: 2).combined(with: .opacity).animation(Animation.easeIn(duration: 0.5)))
            }
            
            Spacer()
            /*
            Button(.createVault, action: model.createVault)
          //      .buttonStyle(ColoredButtonStyle(.accentColor, size: .large, expansion: .fill))
                .disabled(!enabledIntensions.contains(.forward))*/
        }
        /*
        .onReceive(model.error) { error in
            displayError = error
        }
        .alert(item: $displayError) { error in
            switch error {
            case .vaultCreationFailed:
                let title = Text(.invalidPassword)
                return Alert(title: title)
            }
        }
        .onAppear {
            feedbackGenerator.prepare()
            isCheckmarkVisible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                feedbackGenerator.notificationOccurred(.success)
            }
        }*/

    }
    #endif
    
}

#if DEBUG
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
