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
        HStack {
            type.image
                .imageScale(.large)
                .foregroundColor(type.color)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(name)
                
                if let description = description {
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(.secondaryLabel)
                }
            }
        }
    }
    
}
