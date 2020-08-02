import SwiftUI

struct SecureItemDisplayDateField: View {
    
    let title: String
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            FieldLabel(title)
            
            Text(date, style: .date)
        }
        .padding(.vertical)
    }
    
}
