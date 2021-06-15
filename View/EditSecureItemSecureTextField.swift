import SwiftUI

#warning("Todo")
struct EditSecureItemSecureTextField: View {
    
    private let title: LocalizedStringKey
    private let placeholder: LocalizedStringKey
    private let text: Binding<String>
    private let generatorAvailable: Bool
    
    @State private var showGeneratorControls = false
    
    init(_ title: LocalizedStringKey, placeholder: LocalizedStringKey, text: Binding<String>, generatorAvailable: Bool) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.generatorAvailable = generatorAvailable
    }
    
    #if os(iOS)
    var body: some View {
        SecureItemView {
            SecureItemField(title) {
                VStack(spacing: 20) {
                    switch (generatorAvailable, showGeneratorControls) {
                    case (false, _):
                      //  SecureField(placeholder, text: text)
                        Text("foo")
                    case (true, true):
                        GeneratePasswordView { password in
                            guard let password = password else { return }
                            
                            text.wrappedValue = password
                        }
                        
                        Button(.usePassword) {
                            showGeneratorControls = false
                        }
//                        .buttonStyle(ColoredButtonStyle(.accentColor, size: .small, expansion: .fill))
                    case (true, false):
                     //   SecureField(placeholder, text: text)
                        
                        Button(.generatePassword) {
                            showGeneratorControls = true
                        }
               //         .buttonStyle(ColoredButtonStyle(.accentColor, size: .small, expansion: .fill))
                    }
                }
            }
        //    .animation(nil)
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        SecureItemView {
            SecureItemField(title) {
                VStack(alignment: .leading) {
                    switch (generatorAvailable, showGeneratorControls) {
                    case (false, _):
                        //SecureField(placeholder, text: text)
                        Text("foo")
                    case (true, true):
                        GeneratePasswordView { password in
                            guard let password = password else { return }
                            
                            text.wrappedValue = password
                        }
                        
                        Button(.usePassword) {
                            showGeneratorControls = false
                        }
                    case (true, false):
                      //  SecureField(placeholder, text: text)
                        
                        Button(.generatePassword) {
                            showGeneratorControls = true
                        }
                    }
                }
            }
            .animation(nil)
        }
    }
    #endif
    
}

#if DEBUG
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
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
