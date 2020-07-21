import SwiftUI

struct SecureText: View {
    
    let content: String
    
    @Binding var secureDisplay: Bool
    
    var body: some View {
        HStack {
            Text(secureDisplay ? content.secure : content)
            
            Button {
                secureDisplay.toggle()
            } label: {
                Image(systemName: secureDisplay ? "lock.fill" : "lock.open.fill")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
}

private extension String {
    
    var secure: String {
        return String(repeating: "●", count: self.count)
    }
    
}
