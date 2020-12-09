import SwiftUI

struct LoginCredentialView: View {
    
    private let title: String
    private let username: String
    private let url: String?
    
    init(title: String, username: String, url: String?) {
        self.title = title
        self.username = username
        self.url = url
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.body)
                .foregroundColor(.label)
            
            Text(username)
                .font(.footnote)
                .foregroundColor(.secondaryLabel)
            
            if let url = url {
                Text(url)
                    .font(.footnote)
                    .foregroundColor(.secondaryLabel)
            }
        }
    }
    
}
