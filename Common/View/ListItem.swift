import SwiftUI

struct ListItem: View {
    
    let title: String
    let iconName: String
    
    var body: some View {
        return HStack {
            Text(title)
        }
    }
    
}
