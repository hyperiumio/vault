import Haptic
import Localization
import SwiftUI

private let changeFeedback = ChangeFeedbackGenerator()

#if os(iOS)
struct GeneratePasswordView: View {
    
    let passworGenerator: (String?) -> Void
    
    @StateObject private var model = GeneratePasswordModel()
    
    private var length: Binding<Double> {
        Binding<Double> {
            Double(model.length)
        } set: { length in
            let length = Int(length)
            guard model.length != length else { return }
            
            model.length = length
        }
    }
    
    private var passwordLengthText: String {
        LocalizedString.characters(model.length)
    }
    
    private var passwordTextMinHeight: CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        return ceil(font.lineHeight)
    }
    
    init(passworGenerator: @escaping (String?) -> Void) {
        self.passworGenerator = passworGenerator
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.password ?? "")
                .font(.password)
                .foregroundColor(.label)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(minHeight: passwordTextMinHeight)
            
            HStack() {
                Text(passwordLengthText)
                
                Slider(value: length, in: 16 ... 64, step: 1)
            }
            
            Toggle(LocalizedString.numbers, isOn: $model.digitsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            
            Toggle(LocalizedString.symbols, isOn: $model.symbolsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        }
        .font(.text)
        .foregroundColor(.secondaryLabel)
        .onChange(of: model.password, perform: passworGenerator)
        .onChange(of: model.length) { _ in
            changeFeedback.play()
        }
        .onAppear {
            changeFeedback.start()
            model.createPassword()
        }
        .onDisappear {
            changeFeedback.stop()
        }
    }
    
}

private extension Font {
    
    static var password: Self {
        .system(.body, design: .monospaced)
    }
    
    static var text: Self {
        Font.body.monospacedDigit()
    }
    
}
#endif

#if os(iOS) && DEBUG
struct GeneratePasswordViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            GeneratePasswordView { _ in }
                .preferredColorScheme(.light)
            
            GeneratePasswordView { _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
