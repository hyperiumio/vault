import SwiftUI

struct SecureItemEditField: View {
    
    let title: String
    let text: Binding<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            FieldLabel(title)
            
            TextField(title, text: text)
        }
        .padding(.vertical)
    }
    
}
