import SwiftUI

struct VaultItemInfoView: View {
    
    private let name: String
    private let description: String?
    private let type: SecureItemType
    
    init(_ name: String, description: String?, type: SecureItemType) {
        self.name = name
        self.description = description
        self.type = type
    }
    
    var body: some View {
        HStack(spacing: 10) {
            type.image
                .imageScale(.large)
                .frame(width: 25, height: 25)
                .foregroundColor(type.color)
            
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
