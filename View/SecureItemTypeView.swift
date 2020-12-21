import Store
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
            return Image(systemName: SFSymbolName.personFill)
        case .password:
            return Image(systemName: SFSymbolName.keyFill)
        case .wifi:
            return Image(systemName: SFSymbolName.wifi)
        case .note:
            return Image(systemName: SFSymbolName.noteText)
        case .bankCard:
            return Image(systemName: SFSymbolName.creditcard)
        case .bankAccount:
            return Image(systemName: SFSymbolName.dollarsignCircle)
        case .custom:
            return Image(systemName: SFSymbolName.scribbleVariable)
        case .file:
            return Image(systemName: SFSymbolName.paperclip)
        }
    }
    
    static func text(for type: SecureItemType) -> Text {
        switch type {
        case .login:
            return Text(.login)
        case .password:
            return Text(.password)
        case .wifi:
            return Text(.wifi)
        case .note:
            return Text(.note)
        case .bankCard:
            return Text(.bankCard)
        case .bankAccount:
            return Text(.bankAccount)
        case .custom:
            return Text(.custom)
        case .file:
            return Text(.file)
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
