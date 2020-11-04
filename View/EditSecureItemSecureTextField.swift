import Localization
import SwiftUI

#if os(iOS)
struct EditSecureItemSecureTextField: View {
    
    private let title: String
    private let placeholder: String
    private let text: Binding<String>
    private let generatorAvailable: Bool
    
    @State private var showGeneratorControls = false
    
    init(_ title: String, placeholder: String, text: Binding<String>, generatorAvailable: Bool) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.generatorAvailable = generatorAvailable
    }
    
    var body: some View {
        SecureItemView {
            SecureItemField(title) {
                VStack(spacing: 20) {
                    switch (generatorAvailable, showGeneratorControls) {
                    case (false, _):
                        SecureField(placeholder, text: text)
                    case (true, true):
                        GeneratePasswordView { password in
                            guard let password = password else { return }
                            
                            text.wrappedValue = password
                        }
                        
                        Button(LocalizedString.usePassword) {
                            showGeneratorControls = false
                        }
                        .buttonStyle(ColoredButtonStyle(.accentColor, size: .small, expansion: .fill))
                    case (true, false):
                        SecureField(placeholder, text: text)
                        
                        Button(LocalizedString.generatePassword) {
                            showGeneratorControls = true
                        }
                        .buttonStyle(ColoredButtonStyle(.accentColor, size: .small, expansion: .fill))
                    }
                }
            }
            .animation(nil)
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
struct EditSecureItemSecureTextFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        Group {
            List {
                EditSecureItemSecureTextField("foo", placeholder: "bar", text: $text, generatorAvailable: true)
            }
            .preferredColorScheme(.light)
            
            List {
                EditSecureItemSecureTextField("foo", placeholder: "bar", text: $text, generatorAvailable: true)
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
