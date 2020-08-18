import SwiftUI

struct SecureItemToolbarItem: View {
    
    let type: SecureItemType
    
    var body: some View {
        HStack {
            Image(type)
                .foregroundColor(Color(type))
            
            Text(type.title)
        }
    }
    
}
