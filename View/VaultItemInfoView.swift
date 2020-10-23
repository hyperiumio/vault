import SwiftUI

struct VaultItemInfoView: View {
    
    private let name: String
    private let description: String?
    private let image: Image
    
    init(_ name: String, description: String?, type: SecureItemType) {
        self.name = name
        self.description = description
        
        switch type {
        case .password:
            self.image = .password
        case .login:
            self.image = .login
        case .file:
            self.image = .file
        case .note:
            self.image = .note
        case .bankCard:
            self.image = .bankCard
        case .wifi:
            self.image = .wifi
        case .bankAccount:
            self.image = .bankAccount
        case .custom:
            self.image = .custom
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            image
                .frame(width: 25, height: 25)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                
                if let description = description {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.secondaryLabel)
                }
            }
        }
        .padding(.leading, -5)
        .padding(.vertical, 2)

    }
    
}
