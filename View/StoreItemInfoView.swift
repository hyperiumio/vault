import Resource
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
            SecureItemTypeView(type)
                .labelStyle(.iconOnly)
        }
        .padding(.vertical, 4)
    }
    
}

#if DEBUG
struct StoreItemInfoViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            StoreItemInfoView("foo", description: "bar", type: .login)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            StoreItemInfoView("foo", description: "bar", type: .login)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
