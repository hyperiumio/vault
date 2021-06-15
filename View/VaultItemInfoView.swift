import Persistence
import SwiftUI

#warning("Todo")
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
                //Text(title, textStyle: .body, color: .label)
                /*
                if let description = description {
                    //Text(description, textStyle: .footnote, color: .secondaryLabel)
                }*/
            }
            .alignmentGuide(.firstTextBaseline) { dimension in
                dimension[VerticalAlignment.center]
            }
            
        } icon: {
            Self.image(for: type)
                .foregroundColor(.accentColor)
                .alignmentGuide(.firstTextBaseline) { dimension in
                    dimension[VerticalAlignment.center]
                }
        }
        .padding(.vertical, 4)
    }
    
}

private extension VaultItemInfoView {
    
    static func image(for type: SecureItemType) -> Image {
        switch type {
        case .password:
            return Image(systemName: .key)
        case .login:
            return Image(systemName: .person)
        case .file:
            return Image(systemName: .paperclip)
        case .note:
            return Image(systemName: .noteText)
        case .bankCard:
            return Image(systemName: .creditcard)
        case .wifi:
            return Image(systemName: .wifi)
        case .bankAccount:
            return Image(systemName: .dollarsign)
        case .custom:
            return Image(systemName: .scribbleVariable)
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
