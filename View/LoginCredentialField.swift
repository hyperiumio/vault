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

#if DEBUG
struct LoginCredentialFieldPreview: PreviewProvider {
    
    static let item = LoginCredential(id: UUID(), title: "foo", username: "bar", password: "baz", url: "qux")
    
    static var previews: some View {
        List {
            LoginCredentialField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginCredentialField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
