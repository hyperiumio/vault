import SwiftUI

struct StoreItemInfoView: View {
    
    private let title: String
    private let description: String?
    private let type: ItemType
    
    init(_ title: String, description: String?, type: ItemType) {
        self.title = title
        self.description = description
        self.type = type
    }
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                if let description = description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        } icon: {
            Image(systemName: type.symbolName)
                .symbolVariant(.fill)
                .foregroundColor(.accentColor)
        }
        .padding(.vertical, 4)
    }
    
}

extension StoreItemInfoView {
    
    enum ItemType {
        
        case login
        case password
        case wifi
        case note
        case bankCard
        case bankAccount
        case custom
        case file
        
        var symbolName: String {
            switch self {
            case .password:
                return .key
            case .login:
                return .person
            case .file:
                return .paperclip
            case .note:
                return .noteText
            case .bankCard:
                return .creditcard
            case .wifi:
                return .wifi
            case .bankAccount:
                return .dollarsign
            case .custom:
                return .scribbleVariable
            }
        }
        
    }
    
}
