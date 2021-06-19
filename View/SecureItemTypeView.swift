import SwiftUI

#warning("remove")
struct SecureItemTypeView: View {
    
    private let itemType: ItemType
    
    init(_ itemType: ItemType) {
        self.itemType = itemType
    }
    
    var body: some View {
        Label(itemType.assetIdentifier.localizedStringKey, systemImage: itemType.assetIdentifier.systemImage)
    }
    
}

extension SecureItemTypeView {
    
    enum ItemType {
        
        typealias AssetIdentifier = (systemImage: String, localizedStringKey: LocalizedStringKey)
        
        case login
        case password
        case wifi
        case note
        case bankCard
        case bankAccount
        case custom
        case file
        
        var assetIdentifier: AssetIdentifier {
            switch self {
            case .login:
                return (systemImage: .person, localizedStringKey: .login)
            case .password:
                return (systemImage: .key, localizedStringKey: .password)
            case .wifi:
                return (systemImage: .wifi, localizedStringKey: .wifi)
            case .note:
                return (systemImage: .noteText, localizedStringKey: .note)
            case .bankCard:
                return (systemImage: .creditcard, localizedStringKey: .bankCard)
            case .bankAccount:
                return (systemImage: .dollarsign, localizedStringKey: .bankAccount)
            case .custom:
                return (systemImage: .scribbleVariable, localizedStringKey: .custom)
            case .file:
                return (systemImage: .paperclip, localizedStringKey: .file)
            }
        }
        
    }
    
}

#if DEBUG
struct SecureItemTypeViewPreview: PreviewProvider {
    
    static var previews: some View {
        SecureItemTypeView(.login)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
