import SwiftUI
import Model

struct LoginCredentialField: View {
    
    private let item: LoginCredential
    
    init(_ item: LoginCredential) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(item.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(item.username)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let url = item.url {
                Text(url)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
}
