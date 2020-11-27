import SwiftUI

struct VaultItemInfoView: View {
    
    private let title: String
    private let description: String?
    private let type: SecureItemType
    
    init(_ title: String, description: String?, type: SecureItemType) {
        self.title = title
        self.description = description
        self.type = type
    }
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                TextShim(title, textStyle: .body, color: .label)
                
                if let description = description {
                    TextShim(description, textStyle: .footnote, color: .secondaryLabel)
                }
            }
            
        } icon: {
            Self.image(for: type)
                .foregroundColor(.accentColor)
        }
        .labelStyle(CenteredLabelStyle())
        .padding(.vertical, 4)
    }
    
}

private extension VaultItemInfoView {
    
    static func image(for type: SecureItemType) -> Image {
        switch type {
        case .password:
            return .password
        case .login:
            return .login
        case .file:
            return .file
        case .note:
            return .note
        case .bankCard:
            return .bankCard
        case .wifi:
            return .wifi
        case .bankAccount:
            return .bankAccount
        case .custom:
            return .custom
        }
    }
    
}

#if DEBUG
struct VaultItemInfoViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            List {
                VaultItemInfoView("foo", description: "bar", type: .login)
                    .preferredColorScheme(.light)
            }
            
            List {
                VaultItemInfoView("foo", description: "bar", type: .login)
                    .preferredColorScheme(.dark)
            }
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
