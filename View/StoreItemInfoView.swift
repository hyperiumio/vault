import Model
import SwiftUI

struct StoreItemInfoView: View {
    
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

extension SecureItemType {
    
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
