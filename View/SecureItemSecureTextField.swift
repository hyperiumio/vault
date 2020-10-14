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
    @State private var secureDisplay = false
    
    init(_ title: String, placeholder: String, text: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
    }
    
    var body: some View {
        SecureItemDisplayField(title) {
            HStack {
                if secureDisplay {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                        .font(text.wrappedValue.isEmpty ? Font.system(.body) : Font.system(.body, design: .monospaced))
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
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
    }
    
}
