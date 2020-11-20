import Localization
import SwiftUI

struct SecureItemTypeView: View {
    
    private let type: SecureItemType
    
    init(_ type: SecureItemType) {
        self.type = type
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Self.image(for: type)
            
            Self.text(for: type)
        }
    }
    
}

private extension SecureItemTypeView {
    
    static func image(for type: SecureItemType) -> Image {
        switch type {
        case .login:
            return .login
        case .password:
            return .password
        case .wifi:
            return .wifi
        case .note:
            return .note
        case .bankCard:
            return .bankCard
        case .bankAccount:
            return .bankAccount
        case .custom:
            return .custom
        case .file:
            return .file
        }
    }
    
    static func text(for type: SecureItemType) -> Text {
        switch type {
        case .login:
            return Text(LocalizedString.login)
        case .password:
            return Text(LocalizedString.password)
        case .wifi:
            return Text(LocalizedString.wifi)
        case .note:
            return Text(LocalizedString.note)
        case .bankCard:
            return Text(LocalizedString.bankCard)
        case .bankAccount:
            return Text(LocalizedString.bankAccount)
        case .custom:
            return Text(LocalizedString.custom)
        case .file:
            return Text(LocalizedString.file)
        }
    }
    
}

#if DEBUG
struct SecureItemTypeViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            SecureItemTypeView(.login)
                .preferredColorScheme(.light)
            
            SecureItemTypeView(.login)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
