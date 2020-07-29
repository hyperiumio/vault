import SwiftUI

struct FieldLabel: View {
    
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .foregroundColor(.accentColor)
    }
    
}
