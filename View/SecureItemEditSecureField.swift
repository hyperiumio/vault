import SwiftUI

struct SecureItemEditSecureField: View {
    
    let title: String
    let text: Binding<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            FieldLabel(title)
            
            SecureField(title, text: text)
        }
        .padding([.top, .bottom])
    }
    
}
