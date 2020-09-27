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
            }
        }
    }
    
}

struct SecureItemSecureTextEditField: View {
    
    private let title: String
    private let text: Binding<String>
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        SecureItemDisplayField(title) {
            SecureField(title, text: text)
        }
    }
    
}
