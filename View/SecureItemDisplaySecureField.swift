import SwiftUI

struct SecureItemDisplaySecureField: View {
    
    let title: String
    let content: String
    
    @State private var secureDisplay = true
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                FieldLabel(title)
                
                Text(secureDisplay ? "••••••••" : content)
                    .font(.system(.body, design: .monospaced))
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
        .padding(.vertical)
    }
    
}
