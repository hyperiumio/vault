import SwiftUI

struct EditItemSecureField: View {
    
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
    
    var body: some View {
        SecureItemView {
            ItemField(title) {
                VStack(spacing: 20) {
                    switch (generatorAvailable, showGeneratorControls) {
                    case (false, _):
                        SecureField(placeholder, text: text, prompt: nil)
                    case (true, true):
                        GeneratePasswordView { password in
                            guard let password = password else { return }
                            
                            text.wrappedValue = password
                        }
                        
                        Button(.usePassword) {
                            showGeneratorControls = false
                        }
                    case (true, false):
                        SecureField(placeholder, text: text, prompt: nil)
                        
                        Button(.generatePassword) {
                            showGeneratorControls = true
                        }
                    }
                }
            }
        }
    }
    
}

#if DEBUG
struct EditItemSecureFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        List {
            EditItemSecureField("foo", placeholder: "bar", text: $text, generatorAvailable: true)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
