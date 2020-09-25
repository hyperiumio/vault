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
