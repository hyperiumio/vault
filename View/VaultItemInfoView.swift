import Store
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
            return Image(systemName: SFSymbolName.keyFill)
        case .login:
            return Image(systemName: SFSymbolName.personFill)
        case .file:
            return Image(systemName: SFSymbolName.paperclip)
        case .note:
            return Image(systemName: SFSymbolName.noteText)
        case .bankCard:
            return Image(systemName: SFSymbolName.creditcard)
        case .wifi:
            return Image(systemName: SFSymbolName.wifi)
        case .bankAccount:
            return Image(systemName: SFSymbolName.dollarsignCircle)
        case .custom:
            return Image(systemName: SFSymbolName.scribbleVariable)
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
