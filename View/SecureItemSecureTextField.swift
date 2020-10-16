import Localization
import Pasteboard
import SwiftUI

struct SecureItemSecureTextDisplayField: View {
    
    private let title: String
    private let text: String
    @State private var secureDisplay = true
    
    init(_ title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        SecureItemButton {
            Pasteboard.general.string = text
        } content: {
            HStack {
                SecureItemDisplayField(title) {
                    Text(secureDisplay ? "••••••••" : text)
                }
                
                Spacer()
                
                Button {
                    secureDisplay.toggle()
                } label: {
                    if secureDisplay {
                        Image.hideSecret
                    } else {
                        Image.showSecret
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.trailing)
            }
        }
    }
    
}

struct SecureItemSecureTextEditField: View {
    
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
        SecureItemDisplayField(title) {
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
                    .buttonStyle(ColoredButtonStyle(.accentColor, size: .small))
                case (true, false):
                    SecureField(placeholder, text: text)
                    
                    Button(LocalizedString.generatePassword) {
                        showGeneratorControls = true
                    }
                    .buttonStyle(ColoredButtonStyle(.accentColor, size: .small))
                }
            }
        }
    }
    
}
