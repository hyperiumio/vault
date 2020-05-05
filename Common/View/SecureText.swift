import SwiftUI

struct SecureText: View {
    
    let content: String
    
    @Binding var secureDisplay: Bool
    
    var body: some View {
        
        func toggleDisplay() {
            secureDisplay.toggle()
        }
        
        let content = secureDisplay ? self.content.secure : self.content
        let buttonContent = secureDisplay ? "🔓" : "🔒"
        
        return HStack {
            Text(content)
            
            Button(action: toggleDisplay) {
                Text(buttonContent)
            }
        }
    }
    
}

private extension String {
    
    var secure: String {
        return String(repeating: "●", count: self.count)
    }
    
}
