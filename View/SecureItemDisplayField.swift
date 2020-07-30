import SwiftUI

struct SecureItemDisplayField: View {
    
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            FieldLabel(title)
            
            Text(content)
        }
        .padding([.top, .bottom])
    }
    
}
